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
            fileModel = fileExplorerCtrl.getFileModel();
            currentPathText.text = fileExplorerCtrl.getCurrentPath(); // 更新路径显示
        }
    }

    // 文件模型
    property var fileModel: fileExplorerCtrl.getFileModel()

    // 主背景
    Rectangle {
        anchors.fill: parent
        color: "#1E1E1E"  // 深灰色背景
    }

    // 顶部栏
    Rectangle {
        id: topBar
        width: parent.width
        height: 60
        color: "#2D2D2D"  // 浅灰色背景
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

            // Home 按钮
            Button {
                text: "Home"
                font.pixelSize: 16
                Layout.preferredWidth: 80
                Layout.preferredHeight: 40
                background: Rectangle {
                    color: "#2196F3"  // 蓝色按钮
                    radius: 5
                }
                onClicked: fileExplorerCtrl.goHome()
            }

            // 当前路径显示
            Text {
                id: currentPathText
                text: fileExplorerCtrl.getCurrentPath() // 初始路径
                font.pixelSize: 16
                color: "#FFFFFF"  // 白色文字
                Layout.fillWidth: true
                elide: Text.ElideMiddle  // 路径过长时省略中间部分
            }

            // 搜索框
            TextField {
                id: searchBox
                placeholderText: "Search..."
                font.pixelSize: 16
                color: "#FFFFFF"  // 白色文字
                Layout.preferredWidth: 200
                background: Rectangle {
                    color: "#1E1E1E"  // 深灰色背景
                    radius: 5
                }

                // 防抖机制：延迟 300ms 触发搜索
                onTextChanged: {
                    searchTimer.restart();
                }

                Timer {
                    id: searchTimer
                    interval: 300  // 延迟 300ms
                    onTriggered: {
                        if (searchBox.text.length > 0) {
                            fileModel = fileExplorerCtrl.searchFiles(searchBox.text);
                        } else {
                            fileModel = fileExplorerCtrl.getFileModel();
                        }
                    }
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
        currentIndex: -1 // 初始化为 -1，表示没有选中项

        delegate: Rectangle {
            id: fileItem
            width: fileList.width
            height: 60
            color: mouseArea.containsMouse ? "#3A3A3A" : "#2D2D2D"  // 悬停时颜色加深
            radius: 5

            // 图标和文件名布局
            RowLayout {
                anchors.fill: parent
                spacing: 15
                anchors.leftMargin: 15

                // 文件夹/文件图标
                Image {
                    source: modelData.type === "folder" ? "qrc:/modules/FileExplorer/assets/folder.png" : "qrc:/modules/FileExplorer/assets/file.png"
                    sourceSize: Qt.size(32, 32)
                }

                // 文件名
                Text {
                    text: modelData.name
                    font.pixelSize: 18
                    color: "#FFFFFF"  // 白色文字
                    Layout.fillWidth: true
                }

                // 文件大小（如果是文件）
                Text {
                    text: modelData.type === "file" ? fileExplorerCtrl.getFileSize(modelData.name) : ""
                    font.pixelSize: 16
                    color: "#A0A0A0"  // 浅灰色文字
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
                        fileList.currentIndex = index; // 设置当前选中项
                        fileExplorerCtrl.openFile(modelData.name);
                    } else if (mouse.button === Qt.RightButton) {
                        fileList.currentIndex = index; // 设置当前选中项
                        contextMenu.popup();
                    }
                }
            }

            // 右键菜单
            Menu {
                id: contextMenu
                MenuItem {
                    text: "Delete"
                    onTriggered: fileExplorerCtrl.deleteFile(modelData.name);
                }
                MenuItem {
                    text: "Rename"
                    onTriggered: renameDialog.open();
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
                color: "#1E1E1E"  // 深灰色背景
                radius: 5
            }
        }

        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: {
            var oldName = fileList.model[fileList.currentIndex].name; // 获取当前选中的文件名
            var newName = newNameField.text; // 获取用户输入的新文件名
            fileExplorerCtrl.renameFile(oldName, newName); // 调用重命名方法
        }
    }
}