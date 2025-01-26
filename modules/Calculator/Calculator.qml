// modules/Calculator/Calculator.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12


Item {
    width: 400
    height: 600
    property var params: {}  // 接收传递的参数
    property var mainWindow: null  // 接收 mainWindow 的引用

    // CalculatorCtrl {
    //     id: calculatorCtrl
    // }

    // 1. 背景
    Rectangle {
        anchors.fill: parent
        color: Styles.Theme.backgroundColor
    }

    // 2. 显示区域
    Rectangle {
        id: displayArea
        width: parent.width
        height: 150
        color: "#2c3e50"

        Text {
            id: displayText
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                margins: 20
            }
            text: calculatorCtrl.display
            color: "white"
            font.pixelSize: 48
            horizontalAlignment: Text.AlignRight
        }
    }

    // 3. 返回按钮
    Button {
        id: backButton
        anchors {
            top: parent.top
            left: parent.left
            margins: 10
        }
        text: "返回桌面"
        onClicked: {
            if (mainWindow) {
                console.log("calc back")
                mainWindow.closeAllApplications();  // 清除所有应用
            }
        }
    }

    // 4. 按钮区域
    GridLayout {
        anchors {
            top: displayArea.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 10
        }
        columns: 4
        rowSpacing: 10
        columnSpacing: 10

        // 按钮定义
        CalcButton { text: "C"; onClicked: calculatorCtrl.clear() }
        CalcButton { text: "←"; onClicked: calculatorCtrl.backspace() }
        CalcButton { text: "÷"; onClicked: calculatorCtrl.setOperator("/") }
        CalcButton { text: "×"; onClicked: calculatorCtrl.setOperator("*") }

        CalcButton { text: "7"; onClicked: calculatorCtrl.appendNumber("7") }
        CalcButton { text: "8"; onClicked: calculatorCtrl.appendNumber("8") }
        CalcButton { text: "9"; onClicked: calculatorCtrl.appendNumber("9") }
        CalcButton { text: "-"; onClicked: calculatorCtrl.setOperator("-") }

        CalcButton { text: "4"; onClicked: calculatorCtrl.appendNumber("4") }
        CalcButton { text: "5"; onClicked: calculatorCtrl.appendNumber("5") }
        CalcButton { text: "6"; onClicked: calculatorCtrl.appendNumber("6") }
        CalcButton { text: "+"; onClicked: calculatorCtrl.setOperator("+") }

        CalcButton { text: "1"; onClicked: calculatorCtrl.appendNumber("1") }
        CalcButton { text: "2"; onClicked: calculatorCtrl.appendNumber("2") }
        CalcButton { text: "3"; onClicked: calculatorCtrl.appendNumber("3") }
        CalcButton { text: "="; onClicked: calculatorCtrl.calculate() }

        CalcButton { text: "0"; Layout.columnSpan: 2; onClicked: calculatorCtrl.appendNumber("0") }
        CalcButton { text: "."; onClicked: calculatorCtrl.appendDecimal() }
    }

    // 5. 返回桌面的信号
    signal returnToDesktop()
}