import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.12
import QtQuick.Controls 1.2
import Qt.labs.settings 1.0 // 确保导入 Settings 模块


// // 主界面容器
// Window {
//     id: mainWindow
//     visible: false  // 先隐藏等待初始化完成
//     flags: Qt.FramelessWindowHint  // 嵌入式通常无边框
//     color: Theme.backgroundColor
//     width: 1024
//     height: 600
//
//     // 1. 预加载资源
//     FontLoader {
//         id: mainFont; source: "shared/fonts/Roboto-Light.ttf"
//     }
//
//     // 2. 系统服务初始化
//     // SystemTray { id: sysTray }
//
//     // 3. 桌面视图容器
//     Loader {
//         id: desktopLoader
//         anchors.fill: parent
//         // source: "desktop/WinStyleDesktop.qml"
//         source: "ui/Desktop.qml"
//         active: true
//         asynchronous: true
//
//         onStatusChanged: {
//             if (status === Loader.Ready) {
//                 // splashScreen.hide()
//                 mainWindow.visible = true
//             }
//         }
//     }
//
//     // 4. 应用窗口容器
//     StackView {
//         id: appStack
//         anchors.fill: parent
//     }
//
//     // 5. 启动画面
//     // SplashScreen {
//     //     id: splashScreen
//     //     duration: 1500
//     // }
//
//     // 6. 全局事件总线
//     QtObject {
//         id: eventBridge
//
//         // 应用管理信号
//         signal launchApp(string qmlPath, var params)
//
//         signal closeApp()
//
//         // 硬件控制信号
//         signal gpioChanged(int pin, bool state)
//     }
//
//     // 7. 连接C++信号
//     Connections {
//         target: SysMonitor
//         // onCpuOverload: sysTray.showWarning("CPU过载！")
//     }
//
//     // 8. 应用启动器
//     function startApplication(qmlPath, initParams) {
//         appStack.push({
//             item: Qt.resolvedUrl(qmlPath),
//             properties: initParams
//         })
//     }
//
//     // 9. 初始化完成处理
//     Component.onCompleted: {
//         KeyboardHandler.registerShortcuts()
//         eventBridge.launchApp.connect(startApplication)
//     }
// }

import "./ui"

// main.qml

Window {
    id: mainWindow
    visible: true
    width: 1024
    height: 600
    title: "Embedded Desktop"

    // 保存所有已启动的应用实例
    property var runningApplications: []
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

        // 阴影效果
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            radius: 8
            samples: 16
            color: "#80000000"
        }

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
    }

    // 4. 应用启动器
    function startApplication(path, params) {
        console.log("Launching application from path:", path, "with params:", params);

        // 动态创建 Loader
        const loader = Qt.createQmlObject(`
            import QtQuick 2.15
            import QtQuick.Controls 2.15
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
        runningApplications.push(loader);
        currentLoader = loader;  // 设置当前显示的应用

        // 显示应用，隐藏桌面
        loader.visible = true;
        desktop.visible = false;
    }

    // 5. 返回主界面（不清除应用）
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
            // 从列表中移除
            const index = runningApplications.indexOf(currentLoader);
            if (index !== -1) {
                runningApplications.splice(index, 1);
            }

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
        // 遍历并销毁所有应用
        while (runningApplications.length > 0) {
            const loader = runningApplications.pop();
            loader.source = "";  // 清空 Loader
            loader.destroy();    // 销毁实例
        }

        // 清空当前应用引用
        currentLoader = null;

        // 返回桌面
        returnToDesktop();
    }
}