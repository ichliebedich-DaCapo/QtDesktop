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





Item {
    id: desktop
    property int currentPage: 0

    // 1. 壁纸层（简化）
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#2c3e50" }
            GradientStop { position: 1.0; color: "#34495e" }
        }
    }

    // 2. 分页控制器
    TabBar {
        id: tabBar
        width: parent.width
        currentIndex: currentPage
        TabButton { text: "Page 1" }
        TabButton { text: "Page 2" }
    }

    // 3. 页面内容
    SwipeView {
        id: pageView
        anchors {
            top: tabBar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        currentIndex: tabBar.currentIndex

        // 页面1
        GridView {
            id: grid1
            cellWidth: 120
            cellHeight: 120
            model: pageModel.page0

            delegate: Button {
                width: 100
                height: 100
                text: model.name
                icon.name: model.icon
                onClicked: console.log("Launch:", model.qmlPath)
            }
        }

        // 页面2
        GridView {
            id: grid2
            cellWidth: 120
            cellHeight: 120
            model: pageModel.page1

            delegate: Button {
                width: 100
                height: 100
                text: model.name
                icon.name: model.icon
                onClicked: console.log("Launch:", model.qmlPath)
            }
        }
    }

    // 4. 数据模型（简化）
    QtObject {
        id: pageModel
        property var page0: [
            { name: "Camera", icon: "camera", qmlPath: "CameraApp.qml" },
            { name: "GPIO", icon: "settings", qmlPath: "GpioPanel.qml" }
        ]
        property var page1: [
            { name: "Settings", icon: "settings", qmlPath: "Settings.qml" }
        ]
    }
}