import QtQuick 2.9
import QtQuick.Controls 2.12

// components/PageIndicator.qml
// components/PageIndicator.qml
Row {
    property int count
    property int currentIndex

    spacing: 8

    Repeater {
        model: count
        delegate: Rectangle {
            width: 10
            height: 10
            radius: 5
            color: index === currentIndex ? "white" : "#80ffffff"
            Behavior on color { ColorAnimation { duration: 200 } }
        }
    }
}