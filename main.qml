/******************************************************************
 Copyright © Deng Zhimao Co., Ltd. 1990-2030. All rights reserved.
 * @projectName   QDesktop
 * @brief         main.qml
 * @author        Deng Zhimao
 * @email         1252699831@qq.com
 * @date          2020-07-31
 *******************************************************************/
import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.12
import QtQuick.Controls 1.2
import an.weather 1.0
import an.model 1.0
import myDesktop 1.0
import Qt.labs.settings 1.0 // 确保导入 Settings 模块
import "./calculator"
import "./weather"
import "./desktop"
import "./music"
import "./media"
import "./wireless"
import "./fileview"
import "./tcpclient"
import "./tcpserver"
import "./alarms"
import "./udpchat"
import "./photoview"
import "./aircondition"
import "./iotest"
import "./sensor"
import "./system"
import "./radio"
import "./settings"
import "./cameramedia"

Window {
    id: mainWindow
    property int dayOrNight: 0
    property bool myMusicstate: false
    property string currentTimeString
    property string currentTimeStringSecond
    property string currentDateString
    property string currentWeekString
    property bool rebootFlag: false
    property bool poweroffFlag: false
    property bool backFlag: false
    visible: true
    width: WINenv ? 800 : Screen.desktopAvailableWidth
    height: WINenv ? 480 : Screen.desktopAvailableHeight
    property bool smallScreen: width == 480 ? true : false

    // flags:Qt.FramelessWindowHint

    MyDesktop {
        id: myDesktop
        onSysVolumeChanged: {
            system_volume_slider.value = Number(sysVolume)
        }
        onCpuTempChanged: {
            displayCpuTemp.text = "CPU:" + cpuTemp + "℃"
        }
    }

    // 保存设置
    Settings {
        id: settings
        property bool gradientEnabled: false // 默认关闭动态渐变
    }

    // 渐变背景
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                id: color1; position: 0.0; color: "#B2DFDB"
            } // 稍深的蓝绿色
            GradientStop {
                id: color2; position: 1.0; color: "#80CBC4"
            } // 更深的蓝绿色
        }

        // 动态渐变动画
        SequentialAnimation {
            id: gradientAnimation
            loops: Animation.Infinite
            running: settings.gradientEnabled // 根据设置初始化动画状态
            ColorAnimation {
                target: color1
                property: "color"
                from: "#B2DFDB"
                to: "#4DB6AC" // 中间颜色
                duration: 3000
                easing.type: Easing.Linear
            }
            ColorAnimation {
                target: color2
                property: "color"
                from: "#80CBC4"
                to: "#26A69A" // 中间颜色
                duration: 3000
                easing.type: Easing.Linear
            }
            ColorAnimation {
                target: color1
                property: "color"
                from: "#4DB6AC"
                to: "#B2DFDB" // 回到起始颜色
                duration: 3000
                easing.type: Easing.Linear
            }
            ColorAnimation {
                target: color2
                property: "color"
                from: "#26A69A"
                to: "#80CBC4" // 回到起始颜色
                duration: 3000
                easing.type: Easing.Linear
            }
        }
    }


    Timer {
        id: volume_timer
        interval: 5000
        repeat: true
        running: false
        onTriggered: {
            volume_timer.stop()
            desktop_bell.checked = false
        }
    }

    Timer {
        id: menu_timer
        interval: 5000
        repeat: true
        running: false
        onTriggered: {
            menu_timer.stop()
            if (menuBt.checked) {
                hideMenu.start()
                xMoveRight.start()
                opacityAnHide.start()
                menuBt.checked = false
            }
        }
    }

    RoundButton {
        id: backBtn
        z: 109
        x: parent.x + parent.width - 90
        y: parent.y + parent.height / 2 - 50
        width: 60
        height: 60
        focus: false
        visible: mainSwipeView.currentIndex !== 0
        hoverEnabled: enabled
        opacity: hovered ? 1 : 0.5
        background: Rectangle {
            color: "#55ffffff"
            radius: parent.width / 2
        }
        Image {
            anchors.centerIn: parent
            id: backImage
            source: "qrc:/desktop/images/back.png"
        }
        MouseArea {
            anchors.fill: parent
            drag.target: backBtn
            drag.minimumX: 0
            drag.minimumY: 0
            drag.maximumX: mainWindow.width - 60
            drag.maximumY: mainWindow.height - 60
            onClicked: {
                if (mainSwipeView.currentIndex === 3)
                    mainSwipeView.currentIndex = 0
                if (mainSwipeView.currentIndex !== 0 && mainSwipeView.currentIndex !== 3 && backFlag !== true)
                    WINStyle ? mainSwipeView.currentIndex = 0 : mainSwipeView.currentIndex = 3
                if (backFlag)
                    mainSwipeView.currentIndex = 0
            }
        }
    }

    Item {
        id: menuItem
        z: 111
        //visible: mainSwipeView.currentIndex == 0
        visible: false
        anchors.fill: parent

        Rectangle {
            id: menuButtonsBg
            color: "transparent"
            height: 30
            width: 0
            x: menuBt.x
            y: menuBt.y
            radius: 5
            Item {
                visible: menuButtonsBg.x < menuBt.x - 50
                anchors.fill: parent
                Image {
                    id: closeImage
                    source: "qrc:/desktop/images/close.png"
                    anchors.centerIn: parent
                    antialiasing: true
                    width: 25
                    height: 25
                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: {
                            Qt.quit()
                        }
                        onEntered: closeImage.opacity = 0.5
                        onExited: closeImage.opacity = 0.8
                    }
                }
                Image {
                    id: rebootImage
                    source: "qrc:/desktop/images/reboot.png"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    width: 25
                    height: 25
                    antialiasing: true
                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: {
                            rebootFlag = true
                            Qt.quit()
                        }
                        onEntered: rebootImage.opacity = 0.5
                        onExited: rebootImage.opacity = 0.8
                    }
                }

                Image {
                    id: poweroffImage
                    source: "qrc:/desktop/images/poweroff.png"
                    anchors.right: parent.right
                    width: 25
                    height: 25
                    antialiasing: true
                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: {
                            poweroffFlag = true
                            Qt.quit()
                        }
                        onEntered: poweroffImage.opacity = 0.5
                        onExited: poweroffImage.opacity = 0.8
                    }
                }
            }
        }
        PropertyAnimation {
            id: showMenu
            target: menuButtonsBg
            properties: "width"
            from: 0
            to: 180
            duration: 500
        }
        PropertyAnimation {
            id: hideMenu
            target: menuButtonsBg
            properties: "width"
            from: 180
            to: 0
            duration: 500
        }
        PropertyAnimation {
            id: xMoveLeft
            target: menuButtonsBg
            properties: "x"
            from: menuBt.x
            to: menuBt.x - 190
            duration: 500
        }

        PropertyAnimation {
            id: xMoveRight
            target: menuButtonsBg
            properties: "x"
            from: menuBt.x - 190
            to: menuBt.x
            duration: 500
        }

        PropertyAnimation {
            id: opacityAnShow
            target: menuButtonsBg
            properties: "opacity"
            from: 0.0
            to: 0.8
            duration: 500
        }

        PropertyAnimation {
            id: opacityAnHide
            target: menuButtonsBg
            properties: "opacity"
            from: 0.8
            to: 0.0
            duration: 500
        }

        Button {
            id: menuBt
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.topMargin: 5
            anchors.top: parent.top
            width: 40
            height: 20
            checked: false
            style: ButtonStyle {
                background: Rectangle {
                    color: "transparent"
                }
            }
            Text {
                id: menuText
                text: qsTr("…")
                anchors.centerIn: parent
                color: menuBt.hovered ? "white" : "#ccffffff"
                font.pixelSize: 30
            }
            onClicked: {
                menu_timer.start()
                if (!checked) {
                    showMenu.start()
                    xMoveLeft.start()
                    opacityAnShow.start()
                } else {
                    hideMenu.start()
                    xMoveRight.start()
                    opacityAnHide.start()
                }
                checked = !checked
            }
        }

        Button {
            id: desktop_bell
            //visible: WINStyle ? menuBt.visible : false
            visible: false
            anchors.top: menuBt.bottom
            anchors.horizontalCenter: menuBt.horizontalCenter
            anchors.topMargin: 8
            width: 22
            height: 26
            checked: false
            style: ButtonStyle {
                background: Rectangle {
                    color: "transparent"
                    Image {
                        anchors.fill: parent
                        source: "qrc:/desktop/images/bell.png"
                        opacity: desktop_bell.hovered ? 1 : 0.8
                    }
                }
            }
            onClicked: {
                volume_timer.start()
                checked = !checked
                if (checked)
                    myDesktop.getSystemVolume()
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: 300
            height: 80
            radius: 20
            visible: desktop_bell.checked
            color: "#424242"
            Slider {
                id: system_volume_slider
                height: 50
                width: 280
                anchors.centerIn: parent
                updateValueWhileDragging: true
                stepSize: 1
                maximumValue: 127
                property bool handled: false
                onPressedChanged: {
                    handled = !handled
                    volume_timer.start()
                    if (!handled)
                        myDesktop.setSystemVolume(value)
                }
                onValueChanged: {
                    volume_timer.stop()
                }
                style: SliderStyle {
                    groove: Rectangle {
                        width: control.width
                        height: 3
                        radius: 1
                        color: "white"
                        Rectangle {
                            width: styleData.handlePosition
                            height: 3
                            color: "#27e0fb"
                            radius: 1
                        }
                    }
                    handle: Rectangle {
                        width: 1
                        height: 30
                        color: "transparent"
                    }
                }
            }
        }


    }

    Item {
        id: topMenu
        anchors.top: mainWindow.top
        anchors.left: mainWindow.left
        width: mainWindow.width
        height: 30
        Rectangle {
            anchors.fill: topMenu
            //color: "#55111111"
            color: "transparent"
            Text {
                id: netText
                text: qsTr("www.openedv.com")
                color: "white"
                font.bold: true
                font.pixelSize: 20
                anchors.left: alientek.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            Image {
                id: alientek
                source: "qrc:/desktop/images/alientek.png"
                anchors.left: parent.left
                //anchors.leftMargin: mainSwipeView.currentIndex == 0 ? 5 : 40
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: displayCpuTemp
                anchors.verticalCenter: alientek.verticalCenter
                anchors.left: netText.right
                anchors.leftMargin: 10
                text: qsTr("CPU:50℃")
                color: "white"
                font.bold: true
                font.pixelSize: 20
            }

        }
    }

    // 多页面切换
    SwipeView {
        id: mainSwipeView
        anchors.fill: parent
        interactive: false
        orientation: ListView.Vertical

        // 动态加载页面
        Loader {
            id: winStyleDesktopLoader
            active: false
            sourceComponent: WinStyleDesktop {
            }
        }
        Loader {
            id: musicLoader
            active: false
            sourceComponent: Music {
            }
        }
        Loader {
            id: alarmLoader
            active: false
            sourceComponent: Alarm {
            }
        }
        Loader {
            id: weatherLoader
            active: false
            sourceComponent: Weather {
            }
        }
        Loader {
            id: radioLoader
            active: false
            sourceComponent: Radio {
            }
        }
        Loader {
            id: calculatorLoader
            active: false
            sourceComponent: Calculator {
            }
        }
        Loader {
            id: tcpServerLoader
            active: false
            sourceComponent: TcpServer {
            }
        }
        Loader {
            id: tcpClientLoader
            active: false
            sourceComponent: TcpClient {
            }
        }
        Loader {
            id: udpChatLoader
            active: false
            sourceComponent: UdpChat {
            }
        }
        Loader {
            id: photoViewLoader
            active: false
            sourceComponent: PhotoView {
            }
        }
        Loader {
            id: fileViewLoader
            active: false
            sourceComponent: FileView {
            }
        }
        Loader {
            id: airconditionLoader
            active: false
            sourceComponent: Aircondition {
            }
        }
        Loader {
            id: iotestLoader
            active: false
            sourceComponent: Iotest {
            }
        }
        Loader {
            id: sensorLoader
            active: false
            sourceComponent: Sensor {
            }
        }
        Loader {
            id: myWirelessLoader
            active: false
            sourceComponent: MyWireless {
            }
        }
        Loader {
            id: systemLoader
            active: false
            sourceComponent: System {
            }
        }
        Loader {
            id: settingsLoader
            active: false
            sourceComponent: Settings {
            }
        }
        Loader {
            id: myCameraMediaLoader
            active: false
            sourceComponent: MyCameraMedia {
            }
        }

        // 页面切换逻辑
        onCurrentIndexChanged: {
            console.log("Current index changed to:", currentIndex)
            for (let i = 0; i < mainSwipeView.count; i++) {
                mainSwipeView.itemAt(i).active = i === currentIndex;
            }
        }

        // 初始化时加载第一个页面
        Component.onCompleted: {
            onCurrentIndexChanged() // 手动触发页面加载逻辑
        }
    }

    // 控制按钮
    Button {
        id: controlButton
        text: gradientAnimation.running ? "关闭背景渐变" : "开启背景渐变"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20

        onClicked: {
            gradientAnimation.running = !gradientAnimation.running // 切换动画状态
            settings.gradientEnabled = gradientAnimation.running // 保存状态
        }
    }


    Text {
        id: mainTimeText
        visible: false // mainSwipeView.currentIndex == 0
        text: currentTimeString
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.left: parent.left
        anchors.leftMargin: 50
        color: "white"
        font.pixelSize: 30
        font.bold: true
    }

    Text {
        id: weekText
        visible: false // mainSwipeView.currentIndex == 0
        text: currentWeekString
        anchors.top: mainTimeText.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: mainTimeText.horizontalCenter
        color: "#99eeeeee"
        font.pixelSize: 15
        font.bold: true
    }

    function currentDate() {
        return Qt.formatDateTime(new Date(), "ddd yyyy年MM月dd日")
    }

    function currentWeek() {
        // 获取当前日期
        const currentDate = new Date();

        // 映射星期几
        const weekDayMap = {
            "Sun": "周日",
            "周日": "周日",
            "Mon": "周一",
            "周一": "周一",
            "Tue": "周二",
            "周二": "周二",
            "Wed": "周三",
            "周三": "周三",
            "Thu": "周四",
            "周四": "周四",
            "Fri": "周五",
            "周五": "周五",
            "Sat": "周六",
            "周六": "周六"
        };

        // 获取星期几的字符串
        const weekDay = Qt.formatDateTime(currentDate, "ddd");
        const dayOfWeek = weekDayMap[weekDay] || "";

        // 拼接日期信息
        return dayOfWeek + Qt.formatDateTime(currentDate, ",MM月dd日");
    }

    function currentTime() {
        dayOrNight = new Date().getHours()
        return Qt.formatDateTime(new Date(), "hh:mm")
    }

    function currentTimeSecond() {
        dayOrNight = new Date().getHours()
        return Qt.formatDateTime(new Date(), "hh:mm:ss")
    }

    Timer {
        id: timer
        interval: 1000
        repeat: true
        running: true
        property int welcomeTimerCount: 0
        onTriggered: {
            currentTimeString = currentTime()
            currentDateString = currentDate()
            currentWeekString = currentWeek()
            currentTimeStringSecond = currentTimeSecond()
            if (welcomeTimerCount < 4)
                welcomeTimerCount++
            if (welcomeTimerCount == 2)
                welcome_text.text = "欢迎"
            if (welcomeTimerCount == 4) {
                myDesktop.restoreMixerSettings()
                welcome_display.visible = false
                welcomeTimerCount++
            }
        }
        Component.onCompleted: {
            currentTimeString = currentTime()
            currentDateString = currentDate()
            currentWeekString = currentWeek()
        }
    }

    Item {
        id: welcome_display
        anchors.fill: parent
        //visible: !WINenv
        z: 120
        Flickable {
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: parent.height + 20
            Rectangle {
                anchors.fill: parent
                color: "#1f1e58"
                Text {
                    id: welcome_text
                    text: qsTr("正在初始化，请稍候...")
                    color: "white"
                    font.pixelSize: 30
                    font.bold: true
                    anchors.centerIn: parent
                }
            }
        }
    }
}
