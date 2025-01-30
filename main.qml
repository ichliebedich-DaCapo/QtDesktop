import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.12
import QtQuick.Controls 1.2
import Qt.labs.settings 1.0 // 确保导入 Settings 模块


import "./ui"

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
        radius: width / 2  // 圆形按钮
        color: "#1abc9c"  // 更现代的颜色
        border.color: "#16a085"
        border.width: 2
        opacity: 0.9
        z: 100


        // 拖拽功能
        MouseArea {
            anchors.fill: parent
            drag.target: floatingButton
            drag.axis: Drag.XAndYAxis
            drag.minimumX: 0
            drag.maximumX: mainWindow.width - floatingButton.width
            drag.minimumY: 0
            drag.maximumY: mainWindow.height - floatingButton.height

            // 点击功能
            onClicked: {
                mainWindow.returnToDesktop();  // 返回主界面
            }
        }

        // 图标（使用 Unicode 字符或图片）
        Text {
            anchors.centerIn: parent
            text: "🏠"  // 使用 Unicode 字符作为图标
            font.pixelSize: 24
            color: "white"
        }

        // 设置初始位置
        Component.onCompleted: {
            floatingButton.x = mainWindow.width - floatingButton.width - 20;  // 右侧
            floatingButton.y = (mainWindow.height - floatingButton.height) / 2;  // 居中
        }
    }

    // 4. 应用启动器
    function startApplication(path, params) {
        // 检查是否已经存在该应用的 Loader 实例
        if (appInstances[path]) {
            currentLoader = appInstances[path];
        } else {
            // 动态创建 Loader
            const loader = Qt.createQmlObject(`
                import QtQuick 2.12
                import QtQuick.Controls 2.12
                Loader {
                    anchors.fill: parent
                    visible: false
                    source: "${path}"
                    onLoaded: {
                        item.mainWindow = mainWindow;  // 将 mainWindow 传递给应用
                    }
                }
            `, appContainer);

            // 保存 Loader 实例
            appInstances[path] = loader;
            currentLoader = loader;  // 设置当前显示的应用
        }

        // 显示应用，隐藏桌面
        currentLoader.visible = true;  // 恢复可见性
        desktop.visible = false;
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