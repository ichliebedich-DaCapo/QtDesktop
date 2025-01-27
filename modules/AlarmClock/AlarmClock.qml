// AlarmClock.qml
import QtQuick 2.12
import QtQuick.Controls 2.12

import System.Core 1.0

Item {
    id: root
    width: 1024
    height: 600

    AlarmManager {
        id: alarmManager
    }

    SwipeView {
        id: view
        anchors.fill: parent
        currentIndex: 0

        // 时钟页面
        Item {
            width: view.width
            height: view.height

            ClockPage {
                anchors.fill: parent
                alarmManager: alarmManager
            }
        }

        // 闹钟列表页面
        Item {
            width: view.width
            height: view.height

            AlarmListPage {
                anchors.fill: parent
                alarmManager: alarmManager
            }
        }
    }
}