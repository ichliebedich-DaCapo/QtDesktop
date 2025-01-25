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

// main.qml
Window {
    id: mainWindow
    visible: true
    width: 1024  // 固定宽度
    height: 600  // 固定高度
    title: "Embedded Desktop"

    // 1. 桌面容器
    Loader {
        id: desktopLoader
        anchors.fill: parent
        source: "ui/Desktop.qml"
        active: true

        onLoaded: {
            // 连接桌面信号
            desktopLoader.item.appLaunched.connect(startApplication)
        }
    }

    // 2. 应用窗口容器
    StackView {
        id: appStack
        anchors.fill: parent
    }

    // 3. 应用启动器
    function startApplication(appPath, params) {
        appStack.push({
            item: Qt.resolvedUrl(appPath),
            properties: params
        })
    }

    Component.onCompleted: {
        desktopLoader.item.addPage("Page 3")
        desktopLoader.item.addPage("Page 4")
        desktopLoader.item.addApp(2, "Music2", "music", "modules/MusicApp/MusicPlayer.qml")
        desktopLoader.item.addApp(3, "Browser2", "web", "modules/BrowserApp/Browser.qml")

        desktopLoader.item.enterEditMode()
        desktopLoader.item.deletePage(1)  // 删除Page 2
        desktopLoader.item.deleteApp(0, 1)  // 删除Page 1的第二个应用
        desktopLoader.item.exitEditMode()
    }
}