import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: loginDialog
    title: qsTr("系统登录")
    modal: true
    closePolicy: Dialog.NoAutoClose
    width: 400
    height: 250
    
    // 确保对话框在主窗口中居中显示
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    
    // 设置对话框背景
    background: Rectangle {
        color: "#f5f5f5"
        border.color: "#d0d0d0"
        border.width: 1
        radius: 5
    }
    
    // 设置标题样式
    header: Rectangle {
        color: "#e0e0e0"
        height: 40
        radius: 5
        
        Label {
            text: qsTr("系统登录")
            font.pixelSize: 16
            font.bold: true
            anchors.centerIn: parent
            color: "#303030"
        }
    }
    
    // 外部传入的属性
    property var passwordUtils
    property string storedPassword
    
    // 登录成功信号
    signal loginSuccess()
    // 添加对话框关闭信号
    signal dialogClosed()
    
    // 主内容区
    contentItem: Rectangle {
        color: "transparent"
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20
            
            Label {
                text: qsTr("请输入密码:")
                font.pixelSize: 14
                font.bold: true
                color: "#404040"
            }
            
            TextField {
                id: passwordField
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                echoMode: TextInput.Password
                placeholderText: qsTr("输入密码")
                onAccepted: loginButton.clicked()
                focus: true
                
                // 美化输入框
                background: Rectangle {
                    border.color: passwordField.activeFocus ? "#4a90e2" : "#c0c0c0"
                    border.width: passwordField.activeFocus ? 2 : 1
                    radius: 4
                }
                
                font.pixelSize: 14
                leftPadding: 10
            }
            
            // 添加一个占位空间，使按钮更靠下
            Item {
                Layout.fillHeight: true
                Layout.minimumHeight: 10
            }
            
            // 按钮行
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                spacing: 20
                
                Button {
                    text: qsTr("退出")
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 40
                    onClicked: Qt.quit()
                    
                    // 美化按钮
                    background: Rectangle {
                        color: parent.down ? "#d0d0d0" : "#e0e0e0"
                        border.color: "#b0b0b0"
                        border.width: 1
                        radius: 4
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14
                        color: "#404040"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                
                Button {
                    id: loginButton
                    text: qsTr("登录")
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 40
                    highlighted: true
                    
                    // 美化按钮
                    background: Rectangle {
                        color: parent.down ? "#3a80d2" : "#4a90e2"
                        border.color: "#3a70c2"
                        border.width: 1
                        radius: 4
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        if (passwordUtils.verifyPassword(passwordField.text, storedPassword)) {
                            loginDialog.close();
                            loginSuccess();
                        } else {
                            passwordField.text = "";
                            passwordField.placeholderText = qsTr("密码错误，请重试");
                        }
                    }
                }
            }
        }
    }
    
    // 修改对话框的边距，确保内容不会超出边界
    margins: 0
    padding: 0
    
    // 添加关闭信号处理，通知外部对话框已关闭
    onClosed: {
        // 发送自定义关闭信号，而不是尝试销毁自己
        dialogClosed();
    }
    
    Component.onCompleted: open()
} 