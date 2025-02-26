import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: passwordChangeDialog
    title: qsTr("修改密码")
    modal: true
    width: 400
    height: 450  // 增加高度确保所有内容可见
    
    // 确保对话框在主窗口中居中显示
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    
    // 防止点击外部自动关闭
    closePolicy: Dialog.NoAutoClose
    
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
            text: qsTr("修改密码")
            font.pixelSize: 16
            font.bold: true
            anchors.centerIn: parent
            color: "#303030"
        }
    }
    
    // 外部传入的属性
    property var passwordUtils
    property string storedPassword
    
    // 密码修改成功信号
    signal passwordChanged(string newHashedPassword)
    // 添加对话框关闭信号
    signal dialogClosed()
    
    // 主内容区 - 使用更简单的布局
    contentItem: Item {
        width: parent.width
        height: parent.height - 110  // 减去标题和底部区域的高度
        
        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20
            
            // 当前密码
            Column {
                width: parent.width
                spacing: 8
                
                Label {
                    text: qsTr("当前密码:")
                    font.pixelSize: 14
                    font.bold: true
                    color: "#404040"
                }
                
                TextField {
                    id: currentPasswordField
                    width: parent.width
                    height: 40
                    echoMode: TextInput.Password
                    placeholderText: qsTr("输入当前密码")
                    focus: true
                    
                    background: Rectangle {
                        border.color: currentPasswordField.activeFocus ? "#4a90e2" : "#c0c0c0"
                        border.width: currentPasswordField.activeFocus ? 2 : 1
                        radius: 4
                    }
                    
                    font.pixelSize: 14
                    leftPadding: 10
                }
            }
            
            // 新密码
            Column {
                width: parent.width
                spacing: 8
                
                Label {
                    text: qsTr("新密码:")
                    font.pixelSize: 14
                    font.bold: true
                    color: "#404040"
                }
                
                TextField {
                    id: newPasswordField
                    width: parent.width
                    height: 40
                    echoMode: TextInput.Password
                    placeholderText: qsTr("输入新密码")
                    
                    background: Rectangle {
                        border.color: newPasswordField.activeFocus ? "#4a90e2" : "#c0c0c0"
                        border.width: newPasswordField.activeFocus ? 2 : 1
                        radius: 4
                    }
                    
                    font.pixelSize: 14
                    leftPadding: 10
                }
            }
            
            // 确认新密码
            Column {
                width: parent.width
                spacing: 8
                
                Label {
                    text: qsTr("确认新密码:")
                    font.pixelSize: 14
                    font.bold: true
                    color: "#404040"
                }
                
                TextField {
                    id: confirmPasswordField
                    width: parent.width
                    height: 40
                    echoMode: TextInput.Password
                    placeholderText: qsTr("再次输入新密码")
                    onAccepted: confirmButton.clicked()
                    
                    background: Rectangle {
                        border.color: confirmPasswordField.activeFocus ? "#4a90e2" : "#c0c0c0"
                        border.width: confirmPasswordField.activeFocus ? 2 : 1
                        radius: 4
                    }
                    
                    font.pixelSize: 14
                    leftPadding: 10
                }
            }
        }
    }
    
    // 使用footer来放置按钮，确保它们始终在对话框底部
    footer: Rectangle {
        width: parent.width
        height: 70
        color: "#f5f5f5"
        
        Row {
            anchors.centerIn: parent
            spacing: 20
            
            Button {
                width: 100
                height: 40
                text: qsTr("取消")
                
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
                
                onClicked: {
                    clearFields();
                    passwordChangeDialog.close();
                }
            }
            
            Button {
                id: confirmButton
                width: 100
                height: 40
                text: qsTr("确认")
                
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
                    // 验证当前密码
                    if (!passwordUtils.verifyPassword(currentPasswordField.text, storedPassword)) {
                        currentPasswordField.text = "";
                        currentPasswordField.placeholderText = qsTr("当前密码错误");
                        return;
                    }
                    
                    // 验证两次输入的新密码是否一致
                    if (newPasswordField.text !== confirmPasswordField.text) {
                        confirmPasswordField.text = "";
                        confirmPasswordField.placeholderText = qsTr("两次密码不一致");
                        return;
                    }
                    
                    // 更新密码并发出信号
                    var newHashedPassword = passwordUtils.hashPassword(newPasswordField.text);
                    passwordChanged(newHashedPassword);
                    
                    // 清空并关闭对话框
                    clearFields();
                    passwordChangeDialog.close();
                }
            }
        }
    }
    
    // 清空所有字段的辅助函数
    function clearFields() {
        currentPasswordField.text = "";
        newPasswordField.text = "";
        confirmPasswordField.text = "";
        currentPasswordField.placeholderText = qsTr("输入当前密码");
        newPasswordField.placeholderText = qsTr("输入新密码");
        confirmPasswordField.placeholderText = qsTr("再次输入新密码");
    }
    
    // 添加关闭信号处理，通知外部对话框已关闭
    onClosed: {
        // 发送自定义关闭信号
        dialogClosed();
    }
} 