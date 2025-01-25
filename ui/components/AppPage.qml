// components/AppPage.qml
import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property var pageData
    property real iconSize

    signal componentClicked(string type, string path, var params)

    // 定义函数
    function getComponentWidth(size) {
        switch (size) {
            case "1x1": return iconSize
            case "2x2": return iconSize * 2 + 20
            case "3x3": return iconSize * 3 + 40
            default: return iconSize
        }
    }

    function getComponentHeight(size) {
        switch (size) {
            case "1x1": return iconSize
            case "2x2": return iconSize * 2 + 40
            case "3x3": return iconSize * 3 + 60
            default: return iconSize
        }
    }

    function getComponentSource(component) {
        switch (component.type) {
            case "app": return "AppIcon.qml"
            case "widget": return component.component
            default: return "AppIcon.qml"
        }
    }

    GridView {
        id: gridView
        anchors.fill: parent
        cellWidth: iconSize + 20
        cellHeight: iconSize + 40
        model: pageData.components  // 页面数据里的各个组件和应用

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