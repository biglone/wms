import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 5.9

Rectangle {
    id: monitorView
    anchors.fill: parent
    color: "#000000"  // 黑色背景更适合视频显示
    
    // 添加属性来存储RTSP URL
    property string rtspUrl: "rtsp://10.211.55.2:8554/test"
    
    // 视频播放组件
    MediaPlayer {
        id: mediaPlayer
        source: monitorView.rtspUrl
        autoPlay: true
        
        onError: {
            console.error("MediaPlayer error:", errorString)
            statusText.text = qsTr("播放错误: ") + errorString
        }
        
        onPlaybackStateChanged: {
            console.log("Playback state changed to:", playbackState)
            if (playbackState === MediaPlayer.PlayingState) {
                statusText.text = qsTr("正在播放...")
            } else if (playbackState === MediaPlayer.PausedState) {
                statusText.text = qsTr("已暂停")
            } else if (playbackState === MediaPlayer.StoppedState) {
                statusText.text = qsTr("已停止")
            }
        }
        
        // 添加状态变化处理
        onStatusChanged: {
            console.log("Media status changed to:", status)
            if (status === MediaPlayer.Loaded || status === MediaPlayer.Buffered) {
                if (playbackState === MediaPlayer.PlayingState) {
                    statusText.text = qsTr("正在播放...")
                }
            } else if (status === MediaPlayer.Loading) {
                statusText.text = qsTr("正在加载...")
            } else if (status === MediaPlayer.NoMedia) {
                statusText.text = qsTr("无媒体源")
            } else if (status === MediaPlayer.InvalidMedia) {
                statusText.text = qsTr("无效媒体源")
            }
        }
    }

    VideoOutput {
        id: videoOutput
        anchors.fill: parent
        source: mediaPlayer
    }

    // 视频显示区域
    Rectangle {
        id: videoArea
        anchors.fill: parent
        color: "transparent"  // 改为透明，避免遮挡视频

        // 十字准星
        Rectangle {
            id: crosshairVertical
            anchors.centerIn: parent
            width: 2
            height: 20
            color: "#00ff00"  // 绿色
        }

        Rectangle {
            id: crosshairHorizontal
            anchors.centerIn: parent
            width: 20
            height: 2
            color: "#00ff00"  // 绿色
        }
    }

    // 右侧状态信息
    Rectangle {
        id: statusInfo
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        width: 200
        height: 50
        color: "#333333"
        opacity: 0.8
        radius: 5

        Text {
            id: statusText
            anchors.fill: parent
            anchors.margins: 5
            color: "#ffffff"
            text: mediaPlayer.playbackState === MediaPlayer.PlayingState ?
                  qsTr("正在播放...") : qsTr("准备中...")
            wrapMode: Text.WordWrap
            font.pixelSize: 12
        }
    }

    // 添加控制按钮
    Row {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 10
        spacing: 5
        
        Button {
            text: qsTr("暂停")
            onClicked: mediaPlayer.pause()
        }
        
        Button {
            text: qsTr("重新加载")
            onClicked: {
                mediaPlayer.stop()
                mediaPlayer.source = ""
                mediaPlayer.source = monitorView.rtspUrl
                mediaPlayer.play()
                // 状态文本会通过onStatusChanged和onPlaybackStateChanged自动更新
            }
        }
    }

    // 添加计时器来检查播放状态
    Timer {
        id: statusCheckTimer
        interval: 500  // 每500毫秒检查一次
        repeat: true
        running: mediaPlayer.source != ""
        
        onTriggered: {
            if (mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                statusText.text = qsTr("正在播放...")
            }
        }
    }

    // 添加函数来更改URL并重新加载
    function changeRtspUrl(newUrl) {
        rtspUrl = newUrl
        mediaPlayer.stop()
        mediaPlayer.source = ""
        mediaPlayer.source = rtspUrl
        mediaPlayer.play()
        statusText.text = qsTr("正在连接到新地址...")
    }
}
