//
// property var params: {}  // 接收传递的参数
// property var mainWindow: null  // 接收 mainWindow 的引用
//
// Button {
//     id: backButton
//     anchors {
//         top: parent.top
//         left: parent.left
//         margins: 10
//     }
//     text: "返回桌面"
//     onClicked: {
//         if (mainWindow) {
//             console.log("calc back")
//             mainWindow.closeAllApplications();  // 清除所有应用
//         }
//     }
// }


// modules/Calculator/Calculator.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Calculator 1.0

Item {
    width: 1024
    height: 560  // 适配桌面高度，考虑顶部栏

    CalculatorCtrl {
        id: calculatorCtrl
    }

    Rectangle {
        anchors.fill: parent
        color: "#f0f0f0"

        // 显示计算结果
        Text {
            id: display
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            text: calculatorCtrl.display
            font.pixelSize: 40
            color: "#333"
        }

        // 数字和操作按钮
        Grid {
            anchors.centerIn: parent
            columns: 4
            spacing: 10

            CalcButton { text: "7"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "8"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "9"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "/"; onClicked: calculatorCtrl.setOperation(text) }

            CalcButton { text: "4"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "5"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "6"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "*"; onClicked: calculatorCtrl.setOperation(text) }

            CalcButton { text: "1"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "2"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "3"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "-"; onClicked: calculatorCtrl.setOperation(text) }

            CalcButton { text: "0"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "."; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "C"; onClicked: calculatorCtrl.clear() }
            CalcButton { text: "+"; onClicked: calculatorCtrl.setOperation(text) }

            CalcButton { text: "="; onClicked: calculatorCtrl.calculate() }
        }
    }
}