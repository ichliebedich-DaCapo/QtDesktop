import QtQuick 2.9
import QtQuick.Controls 2.12

//     Project/
// ├── core/                   # C++核心模块
// │   ├── drivers/           # 硬件驱动封装
// │   │   ├── GpioDriver.cpp # GPIO控制
// │   │   └── CameraDriver.cpp
// │   ├── SystemMonitor.cpp  # 系统监控
// │   └── AppRegistry.cpp    # 应用注册管理
// ├── modules/               # 应用模块
// │   ├── CameraApp/
// │   │   ├── CameraApp.qml  # 应用主界面
// │   │   ├── CameraCtrl.cpp # 应用专属逻辑
// │   │   └── assets/        # 应用资源
// ├── shared/                # 公共资源
// │   ├── components/        # 通用QML组件
// │   │   ├── AppIcon.qml
// │   │   └── SystemTray.qml
// │   ├── styles/            # 样式定义
// │   │   └── Theme.qml
// │   └── fonts/             # 字体文件
// ├── ui/                    # 主界面体系
// │   ├── Desktop.qml        # 桌面主界面
// │   ├── AppContainer.qml   # 应用窗口容器
// │   └── SplashScreen.qml   # 启动画面
// ├── main.qml               # QML入口文件
// └── main.cpp               # 程序入口


import "components"  // 导入components目录下的QML组件


Item {
    id: desktop
    width: 1024
    height: 600

    // 1. 信号定义
    signal appLaunched(string appPath, var params)

    // 2. 壁纸层
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#2c3e50" }
            GradientStop { position: 1.0; color: "#34495e" }
        }
    }

    // 3. 分页容器
    SwipeView {
        id: swipeView
        anchors.fill: parent
        interactive: true

        // 动态生成页面
        Repeater {
            model: pageModel.pages
            delegate: AppPage {
                pageData: modelData
                iconSize: desktop.iconSize
                onAppClicked: appLaunched(appPath, params)
            }
        }
    }

    // 4. 页面指示器
    PageIndicator {
        count: swipeView.count
        currentIndex: swipeView.currentIndex
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            margins: 20
        }
    }

    // 5. 数据模型
    property var pageModel: ({
        pages: [
            {
                name: "Page 1",
                apps: [
                    { name: "Camera", icon: "camera", path: "modules/CameraApp/CameraApp.qml" },
                    { name: "GPIO", icon: "settings", path: "modules/GpioApp/GpioPanel.qml" }
                ]
            },
            {
                name: "Page 2",
                apps: [
                    { name: "Settings", icon: "settings", path: "modules/SettingsApp/Settings.qml" }
                ]
            }
        ]
    })

    // 6. 配置属性
    property real iconSize: 96
}