import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property var pageData
    property real iconSize

    signal componentClicked(string type, string path, var params)

    // 定义函数
    function getComponentWidth(size) {
        switch (size) {
            case "1x1": return iconSize + 20
            case "2x2": return (iconSize + 20) * 2
            case "3x3": return (iconSize + 20) * 3
            default: return iconSize + 20
        }
    }

    function getComponentHeight(size) {
        switch (size) {
            case "1x1": return iconSize + 40
            case "2x2": return (iconSize + 40) * 2
            case "3x3": return (iconSize + 40) * 3
            default: return iconSize + 40
        }
    }

    function getComponentSource(component) {
        switch (component.type) {
            case "app": return "AppIcon.qml"
            case "widget": return component.component
            default: return "AppIcon.qml"
        }
    }

    // 使用Flow布局替代GridView
    Flow {
        id: flowLayout
        anchors.fill: parent
        spacing: 10

        // 动态生成组件
        Repeater {
            model: pageData.components
            delegate: Loader {
                width: getComponentWidth(modelData.size)
                height: getComponentHeight(modelData.size)
                source: getComponentSource(modelData)

                // 传递属性给加载的组件
                onLoaded: {
                    if (item) {
                        if (modelData.type === "app") {
                            item.icon = modelData.icon
                            item.label = modelData.name
                            item.clicked.connect(() => componentClicked(modelData.type, modelData.path, {}))
                        }
                    }
                }
            }
        }
    }

    // 将componentClicked信号连接到Desktop的onComponentClicked
    Component.onCompleted: {
        componentClicked.connect(desktop.onComponentClicked)
    }
}