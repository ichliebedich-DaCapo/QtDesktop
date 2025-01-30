import QtQuick 2.12
import QtQuick.Controls 2.12


Item {
    id: timeWheelComponent
    signal indexChanged()

    property int model: 60
    property int currentIndex: 0
    property int step: 1

    Rectangle {
        id: wheel
        width: 100
        height: 150
        color: "white"
        radius: 8

        ListView {
            id: listView
            anchors.fill: parent
            clip: true
            model: wheel.model
            preferredHighlightBegin: 0.4
            preferredHighlightEnd: 0.6
            highlightRangeMode: ListView.StrictlyEnforceRange
            snapMode: ListView.SnapToItem

            delegate: Item {
                width: listView.width
                height: 30

                Text {
                    text: index.toString().padStart(2, '0')
                    anchors.centerIn: parent
                    font.pixelSize: (listView.currentIndex === index) ? 24 : 18
                    color: (listView.currentIndex === index) ? wheel.parent.primaryColor : "#7f8c8d"
                    opacity: 1 - Math.min(1, Math.abs(listView.contentY - (index * 30 - listView.height / 2 + 15)) / 50)
                }
            }

            onMovementEnded: {
                wheel.currentIndex = Math.round(contentY / 30 + 2)
                wheel.indexChanged()
            }
        }

        // 中间指示线
        Rectangle {
            width: parent.width
            height: 2
            color: wheel.parent.primaryColor
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}