import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: messageBox
    
    // 可配置属性
    property string message: ""
    property string type: "info"  // 可选: "success", "info", "warning", "error"
    property int displayTime: 3000  // 显示时间(毫秒)
    
    // 根据类型设置颜色
    property var typeColors: {
        "success": "#52c41a",
        "info": "#1890ff",
        "warning": "#faad14",
        "error": "#f5222d"
    }
    
    // 根据类型设置图标
    property var typeIcons: {
        "success": "✓",
        "info": "ℹ",
        "warning": "⚠",
        "error": "✕"
    }
    
    width: messageLayout.width + 40
    height: messageLayout.height + 20
    
    // 居中显示在父元素顶部
    x: (parent.width - width) / 2
    y: 50
    
    // 设置弹出动画
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200 }
        NumberAnimation { property: "y"; from: 0; to: 50; duration: 200; easing.type: Easing.OutQuad }
    }
    
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 200 }
    }
    
    // 设置背景 - 使用嵌套矩形模拟阴影效果
    background: Item {
        // 外层矩形（模拟阴影）
        Rectangle {
            anchors.fill: parent
            anchors.margins: -4
            color: "#20000000"  // 半透明黑色
            radius: 6
        }
        
        // 内层矩形（主背景）
        Rectangle {
            anchors.fill: parent
            color: "white"
            border.color: messageBox.typeColors[messageBox.type]
            border.width: 1
            radius: 4
        }
    }
    
    // 消息内容
    contentItem: RowLayout {
        id: messageLayout
        spacing: 10
        width: implicitWidth
        height: implicitHeight
        
        // 图标
        Rectangle {
            width: 24
            height: 24
            radius: 12
            color: messageBox.typeColors[messageBox.type]
            
            Text {
                anchors.centerIn: parent
                text: messageBox.typeIcons[messageBox.type]
                color: "white"
                font.pixelSize: 14
                font.bold: true
            }
        }
        
        // 消息文本
        Label {
            text: messageBox.message
            font.pixelSize: 14
            color: "#333333"
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }
    }
    
    // 自动关闭计时器
    Timer {
        id: closeTimer
        interval: messageBox.displayTime
        running: false
        repeat: false
        onTriggered: messageBox.close()
    }
    
    // 显示消息的函数
    function showMessage(msg, msgType, time) {
        message = msg || "提示信息";
        type = msgType || "info";
        
        if (time !== undefined) {
            displayTime = time;
        }
        
        open();
        closeTimer.restart();
    }
} 