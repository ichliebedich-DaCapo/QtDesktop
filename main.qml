import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.12
import QtQuick.Controls 1.2
import Qt.labs.settings 1.0 // 确保导入 Settings 模块


import "./ui"
import "./ui/components"

// main.qml

Window {
    id: mainWindow
    visible: true
    width: 1024
    height: 600
    title: "Embedded Desktop"

    // 保存所有已启动的应用实例
    property var appInstances: ({})  // 使用对象存储 Loader 实例，以 path 为键
    property var currentLoader: null  // 当前显示的应用


    // 1. 桌面容器
    Desktop {
        id: desktop
        anchors.fill: parent
        visible: true  // 默认显示桌面

        onComponentClicked: (type, path, params) => {
            mainWindow.startApplication(path, params);
        }
    }

    // 2. 应用窗口容器（动态创建 Loader 实例）
    Item {
        id: appContainer
        anchors.fill: parent
    }

    // 3. 悬浮按钮（返回主界面）
    Rectangle {
        id: floatingButton
        width: 60
        height: 60
        radius: width / 2
        color: "#1abc9c"
        border.color: "#16a085"
        border.width: 2
        opacity: 0.9
        z: 9999  // 确保最高层级


        // 拖拽功能（兼容实现）
        MouseArea {
            id: dragArea
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.XAndYAxis
            drag.minimumX: 0
            drag.maximumX: mainWindow.width - width
            drag.minimumY: 0
            drag.maximumY: mainWindow.height - height
            preventStealing: true  // 防止事件被窃取

            // 点击功能
            onClicked: mainWindow.returnToDesktop()
        }

        // 图标
        Text {
            anchors.centerIn: parent
            text: "🏠"
            font.pixelSize: 24
            color: "white"
        }

        // 初始位置
        Component.onCompleted: {
            x = mainWindow.width - width - 20;
            y = (mainWindow.height - height) / 2;
        }

        // 边界限制（兼容写法）
        onXChanged: {
            if(x < 0) x = 0;
            else if(x > mainWindow.width - width) x = mainWindow.width - width;
        }
        onYChanged: {
            if(y < 0) y = 0;
            else if(y > mainWindow.height - height) y = mainWindow.height - height;
        }
    }


    // 新增任务切换器
    TaskSwitcher {
        id: taskSwitcher
        anchors.fill: parent
        appModel: taskSwitcherModel
        onCloseApp: closeApplication(path)
        onExitSwitcher: {
            taskSwitcher.visible = false
            returnToDesktop()
        }
    }

    // 新增手势检测区域
    MouseArea {
        id: globalSwipeDetector
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        height: 100
        preventStealing: true

        property real startY: 0

        onPressed: startY = mouseY
        onPositionChanged: {
            if (mouseY < startY - 50 && !taskSwitcher.visible) {
                showTaskSwitcher()
            }
        }
    }

    // 新增数据模型
    ListModel { id: taskSwitcherModel }

    // 新增函数：更新任务切换器模型
    function updateTaskSwitcherModel() {
        taskSwitcherModel.clear()
        for (var path in appInstances) {
            var appName = getAppNameFromPath(path)
            taskSwitcherModel.append({appPath: path, appName: appName})
        }
    }

    // 新增函数：从路径提取应用名称
    function getAppNameFromPath(path) {
        return path.split('/').pop().replace('.qml', '')
    }

    // 修改函数：显示任务切换器
    function showTaskSwitcher() {
        updateTaskSwitcherModel()
        taskSwitcher.visible = true
        desktop.visible = false
        if (currentLoader) currentLoader.visible = false
    }

    // 修改函数：关闭指定应用
    function closeApplication(path) {
        if (appInstances[path]) {
            if (currentLoader === appInstances[path]) currentLoader = null
            appInstances[path].destroy()
            delete appInstances[path]
            updateTaskSwitcherModel()
        }
    }


    // 4. 应用启动器
    function startApplication(path, params) {
        if (appInstances[path]) {
            currentLoader = appInstances[path]
        } else {
            const loader = Qt.createQmlObject(`
            import QtQuick 2.12
            import QtQuick.Controls 2.12
            Loader {
                anchors.fill: parent
                visible: false
                source: "${path}"
                onLoaded: item.mainWindow = mainWindow
            }`, appContainer)

            appInstances[path] = loader
            currentLoader = loader
            updateTaskSwitcherModel() // 新增：更新任务切换器模型
        }

        currentLoader.visible = true
        desktop.visible = false
        taskSwitcher.visible = false // 新增：确保任务切换器隐藏
    }

    // 5. 返回主界面（隐藏当前应用）
    function returnToDesktop() {
        if (currentLoader) {
            currentLoader.visible = false;  // 隐藏当前应用
        }
        desktop.visible = true;  // 显示桌面
    }

    // 6. 清除当前应用
    function closeCurrentApplication() {
        console.log("Closing current application.");
        if (currentLoader) {
            console.log("Closing application from path:", currentLoader.source);
            // 从 appInstances 中移除
            delete appInstances[currentLoader.source];
            // 销毁 Loader
            currentLoader.source = "";  // 清空 Loader
            currentLoader.destroy();    // 销毁实例
            currentLoader = null;       // 清空当前应用引用
        }

        // 返回桌面
        returnToDesktop();
    }

    // 7. 清除所有应用
    function closeAllApplications() {
        console.log("Closing all applications.");
        // 遍历并销毁所有应用
        for (const path in appInstances) {
            const loader = appInstances[path];
            loader.source = "";  // 清空 Loader
            loader.destroy();    // 销毁实例
        }
        appInstances = {};  // 清空对象
        currentLoader = null;  // 清空当前应用引用

        // 返回桌面
        returnToDesktop();
    }
}