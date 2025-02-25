import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: root
    width: 1280  // 建议使用高清分辨率
    height: 720
    title: "视频监控系统"
    visible: true

    // 使用传统菜单栏替代工具栏
    menuBar: MenuBar {
        // 设置菜单
        Menu {
            title: qsTr("设置")
            
            MenuItem { 
                text: qsTr("摄像机及声音阵列")
                onTriggered: cameraDialog.open() 
            }
            MenuItem { 
                text: qsTr("记录及执法")
                onTriggered: console.log("记录设置") 
            }
            MenuItem { 
                text: qsTr("密码修改")
                onTriggered: console.log("修改密码") 
            }
        }
        
        // 操作菜单
        Menu {
            title: qsTr("操作")
            
            MenuItem { 
                text: qsTr("启动")
                onTriggered: console.log("启动系统") 
            }
            MenuItem { 
                text: qsTr("停止并退出")
                onTriggered: Window.close()
            }
        }
        
        // 监控菜单
        Menu {
            title: qsTr("监控")
            
            MenuItem { 
                text: qsTr("监控视图")
                onTriggered: {
                    defaultView.visible = false
                    monitorViewLoader.source = "qrc:/src/qml/views/MonitorView.qml"
                    monitorViewLoader.visible = true
                }
            }
        }
        
        // 帮助菜单
        Menu {
            title: qsTr("帮助")
            
            MenuItem { 
                text: qsTr("关于")
                onTriggered: console.log("显示关于信息") 
            }
        }
    }

    // 主内容区域
    Rectangle {
        anchors.fill: parent
        color: "#e6e6e6"  // 改为浅灰白色背景

        // 默认显示空白区域
        Rectangle {
            id: defaultView
            anchors.fill: parent
            anchors.margins: 10
            color: "#f5f5f5"
            visible: true
        }

        // 监控视图
        Loader {
            id: monitorViewLoader
            anchors.fill: parent
            source: ""  // 初始为空
            visible: false
        }

        // 状态栏
        Rectangle {
            id: statusBar
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 30
            color: "#d9d9d9"  // 稍深一点的灰白色作为状态栏

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                color: "#333333"  // 深灰色文字
                text: qsTr("就绪")
            }
        }
    }

    // 建议使用Dialog组件
    Dialog {
        id: cameraDialog
        title: qsTr("摄像机设置")
        // ... 对话框内容
    }
} 