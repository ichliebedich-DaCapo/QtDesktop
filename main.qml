/******************************************************************
 Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
 * @projectName   QDesktop
 * @brief         main.qml
 * @author        Deng Zhimao
 * @email         1252699831@qq.com
 * @date          2020-07-31
 *******************************************************************/
import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.12
import QtQuick.Controls 1.2
import an.weather 1.0
import an.model 1.0
import myDesktop 1.0
import Qt.labs.settings 1.0 // 确保导入 Settings 模块
import "./calculator"
import "./weather"
import "./desktop"
import "./music"
import "./media"
import "./wireless"
import "./fileview"
import "./tcpclient"
import "./tcpserver"
import "./alarms"
import "./udpchat"
import "./photoview"
import "./aircondition"
import "./iotest"
import "./sensor"
import "./system"
import "./radio"
import "./settings"
import "./cameramedia"

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
    width: 1024  // 固定宽度
    height: 600  // 固定高度
    title: "Embedded Desktop"

    // 保存已启动的应用实例
    property var runningApplications: ({})

    // 1. 桌面容器
    Desktop {
        id: desktop
        anchors.fill: parent

        onComponentClicked: (type, path, params) => {
            mainWindow.startApplication(path, params)
        }
    }


    // 2. 应用窗口容器
    StackView {
        id: appStack
        anchors.fill: parent
        initialItem: desktop  // 将桌面设置为初始页面

    }

    // // 3. 应用启动器
    // function startApplication(path, params) {
    //     console.log("Launching application from path:", path, "with params:", params)
    //
    //     appStack.push({
    //         item: Qt.createComponent(path),
    //         properties:{
    //             stackView: appStack,  // 将 StackView 传递给应用
    //             params: params        // 传递其他参数
    //         }
    //     })
    //
    // }

    // 3. 悬浮按钮（返回主界面）
    Rectangle {
        id: floatingButton
        width: 60
        height: 60
        radius: 30
        color: "lightblue"
        border.color: "gray"
        border.width: 2
        opacity: 0.8

        // 拖拽功能
        MouseArea {
            anchors.fill: parent
            drag.target: floatingButton
            drag.axis: Drag.XAndYAxis
            drag.minimumX: 0
            drag.maximumX: mainWindow.width - floatingButton.width
            drag.minimumY: 0
            drag.maximumY: mainWindow.height - floatingButton.height
        }

        // 点击返回主界面
        Button {
            anchors.centerIn: parent
            text: "Home"
            onClicked: {
                mainWindow.returnToDesktop();  // 返回主界面，但不清除应用
            }
        }
    }

    // 4. 应用启动器
    function startApplication(path, params) {
        // 检查是否已经存在该应用的实例
        if (runningApplications[path]) {
            console.log("Application already running, bringing to front.");
            appStack.push(runningApplications[path]);  // 显示已存在的实例
        } else {
            // 创建新实例
            var component = Qt.createComponent(path);
            if (component.status === Component.Ready) {
                var app = component.createObject(appStack, {
                    stackView: appStack,
                    params: params
                });
                runningApplications[path] = app;  // 保存应用实例
                appStack.push(app);  // 显示新实例
            } else {
                console.error("Failed to load application:", component.errorString());
            }
        }
    }

    // 5. 返回主界面（不清除应用）
    function returnToDesktop() {
        if (appStack.depth > 1) {
            appStack.pop();  // 返回到桌面，但保留应用实例
        }
    }

    // 6. 清除应用
    function closeApplication(path) {
        if (runningApplications[path]) {
            console.log("Closing application:", path);
            var app = runningApplications[path];
            appStack.pop(app);  // 从 StackView 中移除应用
            app.destroy();      // 销毁应用实例
            delete runningApplications[path];  // 从字典中移除
        }
    }

    // 3. 启动 Calculator 的按钮
    Button {
        text: "Launch Calculator"
        anchors.centerIn: parent
        onClicked: {
            console.log("Stack depth:", appStack.depth);
        }
    }

    Component.onCompleted: {
        //
        // desktopLoader.item.addComponent(0, {
        //     type: "widget",
        //     name: "Weather",
        //     component: "qrc:/ui/components/GalleryWidget.qml",
        //     size: "2x2"
        // })
    }
}