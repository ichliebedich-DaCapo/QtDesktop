pragma Singleton
import QtQuick 2.12

QtObject {
    // 颜色定义
    property color background: "#2E2E2E"      // 主背景色（深灰）
    property color surface: "#404040"         // 次级背景色（浅灰）
    property color primary: "#4CAF50"         // 主色调（绿色）
    property color text: "#FFFFFF"            // 文字颜色
    property color divider: "#757575"         // 分割线颜色

    // 字体定义
    property font titleFont: Qt.font({ pixelSize: 20, bold: true })
    property font bodyFont: Qt.font({ pixelSize: 16 })
}