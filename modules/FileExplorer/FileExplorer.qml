import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import com.example.FileExplorer 1.0

Item {
    id: root
    width: 1024
    height: 600

    property var params: {}
    property var mainWindow: null

    // 创建 FileExplorerCtrl 实例
    FileExplorerCtrl {
        id: fileExplorerCtrl
        onFileModelChanged: {
            fileModel = fileExplorerCtrl.getFileModel()
            currentPathText.text = fileExplorerCtrl.getCurrentPath()
        }
    }

    // 文件模型
    property var fileModel: fileExplorerCtrl.getFileModel()

    // 主背景
    Rectangle {
        anchors.fill: parent
        color: "#2E2E2E"  // 深灰色背景
    }

    // 顶部栏
    Rectangle {
        id: topBar
        width: parent.width
        height: 60
        color: "#404040"  // 浅灰色背景
        z: 1  // 确保顶部栏在最上层

        RowLayout {
            anchors.fill: parent
            spacing: 10

            // 返回按钮
            Button {
                text: "←"
                font.pixelSize: 24
                Layout.preferredWidth: 60
                Layout.preferredHeight: 40
                background: Rectangle {
                    color: "#4CAF50"  // 绿色按钮
                    radius: 5
                }
                onClicked: fileExplorerCtrl.goUp()
            }

            // 当前路径显示
            Text {
                id: currentPathText
                text: fileExplorerCtrl.getCurrentPath()
                font.pixelSize: 18
                color: "#FFFFFF"  // 白色文字
                Layout.fillWidth: true
                elide: Text.ElideMiddle  // 路径过长时显示省略号
            }

            // 搜索框
            TextField {
                id: searchBox
                placeholderText: "Search..."
                font.pixelSize: 16
                color: "#FFFFFF"  // 白色文字
                Layout.preferredWidth: 200
                background: Rectangle {
                    color: "#2E2E2E"  // 深灰色背景
                    radius: 5
                }
            }
        }
    }

    // 文件列表
    ListView {
        id: fileList
        width: parent.width
        height: parent.height - topBar.height
        anchors.top: topBar.bottom
        model: fileModel
        clip: true
        spacing: 2

        delegate: Rectangle {
            id: fileItem
            width: fileList.width
            height: 60
            color: mouseArea.containsMouse ? "#505050" : "#404040"  // 悬停时颜色加深
            radius: 5

            // 图标和文件名布局
            RowLayout {
                anchors.fill: parent
                spacing: 15
                anchors.leftMargin: 15

                // 文件夹/文件图标
                Image {
                    source: modelData.endsWith("/") ? "qrc:/modules/FileExplorer/assets/folder.png" : "qrc:/modules/FileExplorer/assets/file.png"
                    sourceSize: Qt.size(32, 32)
                }

                // 文件名
                Text {
                    text: modelData
                    font.pixelSize: 18
                    color: "#FFFFFF"  // 白色文字
                    Layout.fillWidth: true
                }

                // 文件大小（如果是文件）
                Text {
                    text: fileExplorerCtrl.getFileSize(modelData)
                    font.pixelSize: 16
                    color: "#757575"  // 灰色文字
                    visible: !modelData.endsWith("/")
                }
            }

            // 鼠标交互区域
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: {
                    if (mouse.button === Qt.LeftButton) {
                        fileExplorerCtrl.openFile(modelData)
                    } else if (mouse.button === Qt.RightButton) {
                        contextMenu.popup()
                    }
                }
            }

            // 右键菜单
            Menu {
                id: contextMenu
                MenuItem {
                    text: "Delete"
                    onTriggered: fileExplorerCtrl.deleteFile(modelData)
                }
                MenuItem {
                    text: "Rename"
                    onTriggered: renameDialog.open()
                }
            }
        }
    }

    // 重命名对话框
    Dialog {
        id: renameDialog
        title: "Rename File"
        anchors.centerIn: parent
        width: 400

        TextField {
            id: newNameField
            placeholderText: "New name"
            width: parent.width
            font.pixelSize: 16
            color: "#FFFFFF"  // 白色文字
            background: Rectangle {
                color: "#2E2E2E"  // 深灰色背景
                radius: 5
            }
        }

        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: fileExplorerCtrl.renameFile(modelData, newNameField.text)
    }
}