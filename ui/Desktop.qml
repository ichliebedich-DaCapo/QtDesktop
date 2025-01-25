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
import "icons"

// Desktop.qml
Item {
    id: desktop
    width: 1024
    height: 600
    //  配置属性
    property real iconSize: 96

    // 1. 信号定义
    signal componentClicked(string type, string path, var params)


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
                pageData: modelData // 传入的是每个页面的数据，里面有相应的组件和应用
                iconSize: desktop.iconSize
                onComponentClicked: desktop.componentClicked(type, path, params)
            }
        }
    }

    // 4. 页面指示器
    Row {
        id: pageIndicator
        spacing: 12
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            margins: 20
        }

        Repeater {
            model: swipeView.count
            delegate: Rectangle {
                id: dot
                width: 12
                height: 12
                radius: 6
                color: "transparent"
                border.color: index === swipeView.currentIndex ? "#1abc9c" : "#bdc3c7"
                border.width: 2

                Rectangle {
                    anchors.centerIn: parent
                    width: index === swipeView.currentIndex ? 8 : 0
                    height: width
                    radius: width / 2
                    color: "#1abc9c"
                    Behavior on width {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: swipeView.currentIndex = index
                    onEntered: dot.border.color = "#1abc9c"
                    onExited: dot.border.color = index === swipeView.currentIndex ? "#1abc9c" : "#bdc3c7"
                }
            }
        }
    }

    // 5. 数据模型
    property var pageModel: ({
        pages: [
            {
                name: "Page 1",
                components: [
                    {type: "app", name: "Camera", icon: "test", path: "modules/CameraApp/CameraApp.qml", size: "1x1"},
                    {type: "app", name: "GPIO", icon: "test", path: "modules/GpioApp/GpioPanel.qml", size: "1x1"},
                    {type: "widget", name: "Clock", component: "qrc:/ui/components/ClockWidget.qml", size: "2x2"}
                ]
            }, {
                name: "Page 2",
                components: [
                    {type: "app", name: "Camera2", icon: "test", path: "modules/CameraApp/CameraApp.qml", size: "1x1"},
                    {type: "app", name: "GPIO2", icon: "test", path: "modules/GpioApp/GpioPanel.qml", size: "1x1"},
                    {type: "widget", name: "Clock2", component: "ClockWidget.qml", size: "2x2"}
                ]
            }
        ]
    })

    // --------------函数集群--------------
    // 添加新页面
    function addPage(pageName) {
        pageModel.pages.push({
            name: pageName,
            components: []
        })
        pageModelChanged()
    }

    // 添加新组件
    function addComponent(pageIndex, component) {
        console.log("Adding component:", component)
        if (pageIndex >= 0 && pageIndex < pageModel.pages.length) {
            pageModel.pages[pageIndex].components.push(component)
            pageModelChanged()
        } else {
            console.error("Invalid page index:", pageIndex)
        }
    }

    // 编辑界面和组件
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

    function deleteComponent(pageIndex, componentIndex) {
        if (pageIndex >= 0 && pageIndex < pageModel.pages.length) {
            const page = pageModel.pages[pageIndex]
            if (componentIndex >= 0 && componentIndex < page.components.length) {
                page.components.splice(componentIndex, 1)
                pageModelChanged()
            }
        }
    }


}