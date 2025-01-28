// AlarmClock.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import Alarm 1.0

Item {
    id: root
    width: 1024
    height: 600

    property var params: {}
    property var mainWindow: null

    property alias alarmCtrl: controller

    AlarmCtrl { id: controller }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        TimePage { alarmCtrl: controller }
        AlarmPage { alarmCtrl: controller }
    }

    TabBar {
        id: tabBar
        width: parent.width
        currentIndex: swipeView.currentIndex

        TabButton {
            text: qsTr("时钟")
            width: implicitWidth
        }
        TabButton {
            text: qsTr("闹钟")
            width: implicitWidth
        }
    }
}