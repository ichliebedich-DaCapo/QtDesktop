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

    // 顶部菜单
    Item {
        id: topMenu
        anchors.top: mainWindow.top
        anchors.left: mainWindow.left
        width: mainWindow.width
        height: 30
        Rectangle {
            anchors.fill: topMenu
            color: "transparent"

            // 图片
            Image {
                id: top_icon
                source: "qrc:/desktop/images/top_icon.png"
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.verticalCenter: parent.verticalCenter
            }

            // 删除 netText 后，直接将 displayCpuTemp 锚定到 top_icon 的右侧
            Text {
                id: displayCpuTemp
                anchors.verticalCenter: top_icon.verticalCenter
                anchors.left: top_icon.right // 锚定到 top_icon 的右侧
                anchors.leftMargin: 20 // 左边距
                text: qsTr("CPU:50℃")
                color: "white"
                font.bold: true
                font.pixelSize: 20
            }
        }
    }

    // 返回主菜单按钮
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
                if (mainSwipeView.currentIndex === 3) {
                    mainSwipeView.currentIndex = 0; // 如果当前是第 4 页，返回首页
                } else if (mainSwipeView.currentIndex !== 0 && !backFlag) {
                    mainSwipeView.currentIndex = WINStyle ? 0 : 3; // 根据条件切换页面
                } else if (backFlag) {
                    mainSwipeView.currentIndex = 0; // 如果 backFlag 为 true，返回首页
                }
            }
        }
    }


    // 系统音量
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


    Item {
        id: menuItem
        z: 111
        //visible: mainSwipeView.currentIndex == 0
        visible: false
        anchors.fill: parent

        // 设置里的三个选项
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
    }


    // 不知道有什么用
    Button {
        id: menuBt
        anchors.right: parent.right
        anchors.rightMargin: 80
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


    // 多页面切换
    // 其实是多应用切换
    // 多页面切换
    Rectangle {
        anchors.fill: parent
        color: "transparent"

        SwipeView {
            id: mainSwipeView
            anchors.fill: parent
            interactive: false
            orientation: ListView.Vertical
            // Component.onCompleted: {
            //     contentItem.highlightMoveDuration = 0
            // }

            // 存储旧的页面索引，默认为0，即桌面
            property int previousIndex: 0

            // 动态加载页面
            Loader {
                id: winStyleDesktopLoader
                active: true // 初始加载
                asynchronous: true // 启用异步加载
                sourceComponent: WinStyleDesktop {
                }
            }
            Loader {
                id: musicLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: Music {
                }
            }
            Loader {
                id: alarmLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: Alarm {
                }
            }
            Loader {
                id: weatherLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: Weather {
                }
            }
            Loader {
                id: radioLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: Radio {
                }
            }
            Loader {
                id: calculatorLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: Calculator {
                }
            }
            Loader {
                id: tcpServerLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: TcpServer {
                }
            }
            Loader {
                id: tcpClientLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: TcpClient {
                }
            }
            Loader {
                id: udpChatLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: UdpChat {
                }
            }
            Loader {
                id: photoViewLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: PhotoView {
                }
            }
            Loader {
                id: fileViewLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: FileView {
                }
            }
            Loader {
                id: airconditionLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: Aircondition {
                }
            }
            Loader {
                id: iotestLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: Iotest {
                }
            }
            Loader {
                id: sensorLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: Sensor {
                }
            }
            Loader {
                id: myWirelessLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: MyWireless {
                }
            }
            Loader {
                id: systemLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: System {
                }
            }
            Loader {
                id: settingsLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: Settings {
                }
            }
            Loader {
                id: myCameraMediaLoader
                active: false // 初始不加载
                asynchronous: true // 启用异步加载
                sourceComponent: MyCameraMedia {
                }
            }

            // 页面切换逻辑
            onCurrentIndexChanged: {
                // 关闭旧的页面
                if (previousIndex !== 0) {
                    mainSwipeView.itemAt(previousIndex).active = false;
                }

                // 打开新的页面
                mainSwipeView.itemAt(currentIndex).active = true;

                // 更新旧的页面索引
                previousIndex = currentIndex;
            }
        }
    }

    // 控制背景颜色按钮
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


    // 日期时间显示
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
        color: "#99eeee"
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

        // 更新时间、日期和星期信息
        function updateDateTime() {
            currentTimeString = currentTime();
            currentDateString = currentDate();
            currentWeekString = currentWeek();
            currentTimeStringSecond = currentTimeSecond();
        }

        // 预加载资源或初始化数据
        function preloadResources() {
            mainSwipeView.onCurrentIndexChanged();// 初始化加载页面
        }

        onTriggered: {
            updateDateTime(); // 更新时间、日期和星期信息

            if (welcomeTimerCount < 4) { // 缩短显示时间
                welcomeTimerCount++;
            }

            // switch (welcomeTimerCount) {
            //     case 1:
            //         welcome_text.text = "加载中，请稍候...";
            //         preloadResources(); // 开始预加载资源
            //         break;
            //     case 3:
            //         welcome_display.visible = false; // 隐藏欢迎界面
            //         welcome_display.destroy();// 销毁欢迎界面
            //         break;
            // }


        }

        Component.onCompleted: {
            updateDateTime(); // 初始化时间、日期和星期信息
        }
    }

    Item {
        id: welcome_display
        anchors.fill: parent
        visible: false
        z: 120
        Flickable {
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: parent.height + 20
            Rectangle {
                anchors.fill: parent
                color: "#4DB6AC"
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
