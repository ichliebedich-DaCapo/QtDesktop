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
            GradientStop {
                position: 0.0; color: "#2c3e50"
            }
            GradientStop {
                position: 1.0; color: "#34495e"
            }
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
    // Repeater跨文件可能有问题，这里不得已直接把所有逻辑放在这
    Row {
        id: pageIndicator
        spacing: 12  // 增加间距
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            margins: 20
        }

        // 动态生成小圆点
        Repeater {
            model: swipeView.count
            delegate: Rectangle {
                id: dot
                width: 12  // 增大尺寸
                height: 12
                radius: 6  // 完全圆形
                color: "transparent"  // 背景透明
                border.color: index === swipeView.currentIndex ? "#1abc9c" : "#bdc3c7"  // 选中状态为绿色，未选中为灰色
                border.width: 2

                // 选中状态的填充圆
                Rectangle {
                    anchors.centerIn: parent
                    width: index === swipeView.currentIndex ? 8 : 0  // 选中时显示
                    height: width
                    radius: width / 2
                    color: "#1abc9c"  // 绿色
                    Behavior on width {
                        NumberAnimation {
                            duration: 200
                        }
                    }  // 平滑过渡
                }

                // 点击切换页面
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true  // 启用悬停检测
                    onClicked: {
                        swipeView.currentIndex = index
                    }

                    // 悬停效果
                    onEntered: {
                        dot.border.color = "#1abc9c"  // 悬停时变为绿色
                    }
                    onExited: {
                        dot.border.color = index === swipeView.currentIndex ? "#1abc9c" : "#bdc3c7"  // 恢复原色
                    }
                }
            }
        }
    }


    // 5. 数据模型
    property var pageModel: ({
        pages: [
            {
                name: "Page 1",
                apps: [
                    {name: "Camera", icon: "camera", path: "modules/CameraApp/CameraApp.qml"},
                    {name: "GPIO", icon: "settings", path: "modules/GpioApp/GpioPanel.qml"}
                ]
            },
            {
                name: "Page 2",
                apps: [
                    {name: "Settings", icon: "settings", path: "modules/SettingsApp/Settings.qml"}
                ]
            }
        ]
    })


    // --------------函数集群--------------
    // 添加新页面
    function addPage(pageName) {
        // 添加新页面
        pageModel.pages.push({
            name: pageName,
            apps: []  // 初始化为空
        })
        pageModelChanged()  // 触发更新
    }

    // 添加新应用
    function addApp(pageIndex, appName, appIcon, appPath) {
        if (pageIndex >= 0 && pageIndex < pageModel.pages.length) {
            pageModel.pages[pageIndex].apps.push({
                name: appName,
                icon: appIcon,
                path: appPath
            })
            pageModelChanged()  // 触发更新
        } else {
            console.error("Invalid page index:", pageIndex)
        }
    }

    // 编辑界面和应用
    property bool isEditMode: false

    function enterEditMode() {
        isEditMode = true
        console.log("Entered edit mode")
    }

    function exitEditMode() {
        isEditMode = false
        console.log("Exited edit mode")
    }

    function deletePage(pageIndex) {
        if (pageIndex >= 0 && pageIndex < pageModel.pages.length) {
            pageModel.pages.splice(pageIndex, 1)
            pageModelChanged()
        }
    }

    function deleteApp(pageIndex, appIndex) {
        if (pageIndex >= 0 && pageIndex < pageModel.pages.length) {
            const page = pageModel.pages[pageIndex];
            if (appIndex >= 0 && appIndex < page.apps.length) {
                page.apps.splice(appIndex, 1)
                pageModelChanged()
            }
        }
    }


    // // 数据持久化
    // function saveConfig() {
    //     const config = JSON.stringify(pageModel.pages);
    //     console.log("Saving config:", config)
    //     // 实际保存到文件
    // }
    //
    // function loadConfig() {
    //     const config = "[]";  // 从文件加载
    //     pageModel.pages = JSON.parse(config)
    //     pageModelChanged()
    // }

    // 7. 配置属性
    property real iconSize: 96
}