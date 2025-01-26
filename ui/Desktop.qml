import "components"  // 导入components目录下的QML组件
import "icons"

import QtQuick 2.12
import QtQuick.Controls 2.12
// import QtGraphicalEffects 1.15


Item {
    id: desktop
    width: 1024
    height: 600
    property real iconSize: 96

    // 信号定义
    // 从AppPage里传入应用的完整信息，以便后续使用
    signal componentClicked(string type, string path, var params)

    // 1. 壁纸层
    Item {
        anchors.fill: parent

        Rectangle {
            id: wallpaper
            anchors.fill: parent
            z: -1
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#6a89cc" }  // 浅蓝色
                GradientStop { position: 1.0; color: "#82ccdd" }  // 更浅的蓝色
            }
        }

        // 模糊效果
        // FastBlur {
        //     anchors.fill: wallpaper
        //     source: wallpaper
        //     radius: 16  // 模糊半径，可以根据性能调整
        // }
    }


    // 2. 顶部栏
    TopBar {
        id: topBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        z: 1
    }

    // 3. 分页容器
    SwipeView {
        id: swipeView
        anchors {
            top: topBar.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        z: 0  // 中间层
        interactive: true

        // 动态生成页面
        Repeater {
            model: pageModel.pages
            delegate: AppPage {
                pageData: modelData
                iconSize: desktop.iconSize
                // 把AppPage里的点击事件传递给desktop
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
                    {type: "app", name: "计算器", icon: "calc", path: "qrc:/modules/Calculator/Calculator.qml", size: "1x1"},
                    {type: "app", name: "GPIO", icon: "test", path: "qrc:/modules/Gpio/GpioPanel.qml", size: "1x1"},
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