// AlarmClock.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import AlarmClock 1.0

Item {
    id: root
    width: 1024
    height: 600
    property var params: {}
    property var mainWindow: null

    readonly property var daysOfWeek: ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        ClockPage { alarmCtrl: alarmClockCtrl }
        AlarmPage { alarmCtrl: alarmClockCtrl }
    }

    TabBar {
        id: tabBar
        width: parent.width
        position: TabBar.Header
        currentIndex: swipeView.currentIndex

        TabButton { text: "时钟" }
        TabButton { text: "闹钟" }
    }

    AlarmClockCtrl { id: alarmClockCtrl }
}