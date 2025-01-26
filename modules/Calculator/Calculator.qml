// modules/Calculator/Calculator.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Calculator 1.0

Item {
    width: 1024
    height: 560  // 适配桌面高度，考虑顶部栏

    property var params: {}  // 接收传递的参数
    property var mainWindow: null  // 接收 mainWindow 的引用

    Button {
        id: backButton
        anchors {
            top: parent.top
            left: parent.left
            margins: 20
        }
        text: "返回桌面"
        font.pixelSize: 18
        onClicked: {
            if (mainWindow) {
                console.log("calc back")
                mainWindow.closeAllApplications();  // 清除所有应用
            }
        }
    }

    CalculatorCtrl {
        id: calculatorCtrl
    }

    Rectangle {
        anchors.fill: parent
        color: "#e0e0e0"  // 更现代的浅灰色背景

        // 显示完整表达式和当前结果（顶部）
        Column {
            id: displayArea
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 20
            }
            spacing: 10

            Text {
                id: expressionDisplay
                text: calculatorCtrl.expression  // 绑定完整表达式
                color: "#555"
                font.pixelSize: 28
                width: parent.width
                horizontalAlignment: Text.AlignRight
                elide: Text.ElideRight  // 超长内容显示省略号
            }

            Text {
                id: resultDisplay
                text: calculatorCtrl.display  // 绑定当前结果
                color: "#222"
                font.pixelSize: 48
                width: parent.width
                horizontalAlignment: Text.AlignRight
            }
        }

        // 键盘部分（底部）
        Rectangle {
            id: keyboardArea
            anchors {
                top: displayArea.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                margins: 20
                topMargin: 30  // 与显示区域保持一定距离
            }
            color: "transparent"  // 透明背景

            // 按钮布局（使用 Grid）
            Grid {
                anchors.centerIn: parent
                columns: 5  // 5列布局
                spacing: 10  // 按钮之间的间距

                // 第一行：功能键
                CalcButton { text: "AC"; buttonColor: "#e74c3c"; onClicked: calculatorCtrl.clearAll() }
                CalcButton { text: "("; onClicked: calculatorCtrl.appendToExpression(text) }
                CalcButton { text: ")"; onClicked: calculatorCtrl.appendToExpression(text) }
                CalcButton { text: "%"; onClicked: calculatorCtrl.appendToExpression(text) }
                CalcButton { text: "√"; onClicked: calculatorCtrl.appendOperation(text) }

                // 第二行：数字和操作
                CalcButton { text: "7"; onClicked: calculatorCtrl.appendNumber(text) }
                CalcButton { text: "8"; onClicked: calculatorCtrl.appendNumber(text) }
                CalcButton { text: "9"; onClicked: calculatorCtrl.appendNumber(text) }
                CalcButton { text: "÷"; buttonColor: "#3498db"; onClicked: calculatorCtrl.appendOperation(text) }
                CalcButton { text: "x²"; onClicked: calculatorCtrl.appendOperation("²") }

                // 第三行
                CalcButton { text: "4"; onClicked: calculatorCtrl.appendNumber(text) }
                CalcButton { text: "5"; onClicked: calculatorCtrl.appendNumber(text) }
                CalcButton { text: "6"; onClicked: calculatorCtrl.appendNumber(text) }
                CalcButton { text: "×"; buttonColor: "#3498db"; onClicked: calculatorCtrl.appendOperation(text) }
                CalcButton { text: "±"; onClicked: calculatorCtrl.toggleSign() }

                // 第四行
                CalcButton { text: "1"; onClicked: calculatorCtrl.appendNumber(text) }
                CalcButton { text: "2"; onClicked: calculatorCtrl.appendNumber(text) }
                CalcButton { text: "3"; onClicked: calculatorCtrl.appendNumber(text) }
                CalcButton { text: "-"; buttonColor: "#3498db"; onClicked: calculatorCtrl.appendOperation(text) }
                CalcButton { text: "="; height: 140; buttonColor: "#2ecc71"; onClicked: calculatorCtrl.calculate() }  // 跨两行

                // 第五行
                CalcButton { text: "0";  onClicked: calculatorCtrl.appendNumber(text) }
                CalcButton { text: "."; onClicked: calculatorCtrl.appendNumber(text) }
                CalcButton { text: "C"; buttonColor: "#e74c3c"; onClicked: calculatorCtrl.clear() }
                CalcButton { text: "+"; buttonColor: "#3498db"; onClicked: calculatorCtrl.appendOperation(text) }
            }
        }
    }
}