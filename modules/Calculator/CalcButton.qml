// shared/components/CalcButton.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: root
    width: 80
    height: 60
    font.pixelSize: 20
    font.bold: true

    // 自定义属性
    property color buttonColor: "#2c3e50"
    property color pressedColor: "#34495e"
    property color borderColor: "#1abc9c"
    property int borderRadius: 5  // 圆角半径
    property int borderWidth: 2   // 边框宽度
    property color textColor: "#ecf0f1"  // 文字颜色

    // 按钮背景
    background: Rectangle {
        color: root.down ? pressedColor : buttonColor
        border.color: borderColor
        border.width: borderWidth
        radius: borderRadius
    }

    // 按钮文字颜色
    contentItem: Text {
        text: root.text
        font: root.font
        color: textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}