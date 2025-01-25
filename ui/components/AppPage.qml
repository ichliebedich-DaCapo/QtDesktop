import QtQuick 2.9
import QtQuick.Controls 2.12


// components/AppPage.qml
// components/AppPage.qml
Item {
    property var pageData
    property real iconSize

    signal appClicked(string appPath, var params)

    GridView {
        anchors.fill: parent
        cellWidth: iconSize + 20
        cellHeight: iconSize + 40
        model: pageData.apps

        delegate: Button {
            width: iconSize
            height: iconSize
            text: modelData.name
            icon.name: modelData.icon
            onClicked: appClicked(modelData.path, {})
        }
    }
}