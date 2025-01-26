

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

    CalculatorCtrl {
        id: calculatorCtrl
    }


    Rectangle {
        anchors.fill: parent
        color: "#f0f0f0"

        // 显示完整表达式和当前结果
        Column {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20
            spacing: 10

            Text {
                id: expressionDisplay
                text: calculatorCtrl.expression  // 绑定完整表达式
                color: "#666"
                font.pixelSize: 24
                width: parent.width
                horizontalAlignment: Text.AlignRight
                elide: Text.ElideRight  // 超长内容显示省略号
            }

            Text {
                id: resultDisplay
                text: calculatorCtrl.display  // 绑定当前结果
                color: "#333"
                font.pixelSize: 40
                width: parent.width
                horizontalAlignment: Text.AlignRight
            }
        }

        // 按钮布局（使用 GridLayout）
        GridLayout {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 60  // 向下偏移避免覆盖显示区
            columnSpacing: 15
            rowSpacing: 15
            columns: 5  // 5列布局

            // 第一行：功能键
            CalcButton { text: "AC"; onClicked: calculatorCtrl.clearAll() }
            CalcButton { text: "("; onClicked: calculatorCtrl.appendToExpression(text) }
            CalcButton { text: ")"; onClicked: calculatorCtrl.appendToExpression(text) }
            CalcButton { text: "%"; onClicked: calculatorCtrl.appendToExpression(text) }
            CalcButton { text: "√"; onClicked: calculatorCtrl.squareRoot() }

            // 第二行：数字和操作
            CalcButton { text: "7"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "8"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "9"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "÷"; onClicked: calculatorCtrl.appendOperation(text) }
            CalcButton { text: "x²"; onClicked: calculatorCtrl.square() }

            // 第三行
            CalcButton { text: "4"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "5"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "6"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "×"; onClicked: calculatorCtrl.appendOperation(text) }
            CalcButton { text: "±"; onClicked: calculatorCtrl.toggleSign() }

            // 第四行
            CalcButton { text: "1"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "2"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "3"; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "-"; onClicked: calculatorCtrl.appendOperation(text) }
            CalcButton { text: "="; Layout.rowSpan: 2; height: 140; onClicked: calculatorCtrl.calculate() }  // 跨两行

            // 第五行
            CalcButton { text: "0"; Layout.columnSpan: 2; width: 200; onClicked: calculatorCtrl.appendNumber(text) }  // 跨两列
            CalcButton { text: "."; onClicked: calculatorCtrl.appendNumber(text) }
            CalcButton { text: "C"; onClicked: calculatorCtrl.clear() }
            CalcButton { text: "+"; onClicked: calculatorCtrl.appendOperation(text) }
        }
    }
}