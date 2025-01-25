import QtQuick 2.9
import QtQuick.Controls 2.12

// App组件
Item {
    property var pageData
    property real iconSize

    signal componentClicked(string type, string path, var params)

    GridView {
        id: gridView
        anchors.fill: parent
        cellWidth: iconSize + 20
        cellHeight: iconSize + 40
        model: pageData.components

        delegate: Loader {
            width: getComponentWidth(modelData.size)
            height: getComponentHeight(modelData.size)
            source: getComponentSource(modelData.type)

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

            function getComponentSource(type) {
                switch (type) {
                    case "app": return "AppIcon.qml"
                    case "widget": return modelData.component
                    default: return "AppIcon.qml"
                }
            }

            onLoaded: {
                if (item && item.hasOwnProperty("clicked")) {
                    item.clicked.connect(() => componentClicked(modelData.type, modelData.path, {}))
                }
            }
        }
    }
}