import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

Rectangle {
    color: backgroundColor
    radius: bubbleRadius
    height: bubbleHeight
    width: hasNotif ? screen.width * .125 : 0
    clip: true
    opacity: hasNotif ? 1.0 : 0.0

    property bool suppressResizeAnim: false

    Behavior on width {
        enabled: !root.suppressResizeAnim
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }
    Behavior on opacity {
        enabled: !root.suppressResizeAnim
        NumberAnimation { duration: hasNotif ? 250 : 150; easing.type: Easing.OutCubic }
    }

    id: root

    property NotificationServer server: NotificationServer {}

    property string notifSender: ""
    property string notifBody: ""
    property string notifChannel: ""
    property bool hasNotif: notifSender !== ""

    function dismiss() {
        notifSender  = ""
        notifBody    = ""
        notifChannel = ""
    }

    SequentialAnimation {
        id: dismissAnim
        NumberAnimation { target: root; property: "scale"; to: 1.05; duration: 60; easing.type: Easing.OutQuad }
        NumberAnimation { target: root; property: "scale"; to: 0.0; duration: 130; easing.type: Easing.InCubic }
        ScriptAction {
            script: {
                root.suppressResizeAnim = true
                root.dismiss()
                root.scale = 1.0
                root.suppressResizeAnim = false
            }
        }
    }

    Connections {
        target: root.server
        function onNotification(notification) {
            if (!notification.appName.toLowerCase().includes("discord")) return

            let summary = notification.summary
            let body    = notification.body

            let chanMatch = summary.match(/^(.+?)\s+\(#(.+?)\)$/)
            if (chanMatch) {
                notifSender  = chanMatch[1]
                notifChannel = "#" + chanMatch[2]
            } else {
                notifSender  = summary
                notifChannel = ""
            }
            notifBody = body

            clearTimer.restart()
        }
    }

    property real fillOpacity: hasNotif ? 0.18 : 0.0
    Behavior on fillOpacity {
        NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
    }

    Rectangle {
        anchors.fill: parent
        radius: bubbleRadius
        color: backgroundColor
        opacity: parent.fillOpacity
    }

    Timer {
        id: clearTimer
        interval: 30000
        onTriggered: root.dismiss()
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 6
        anchors.rightMargin: 12
        spacing: 8

        ColumnLayout {
            spacing: 1
            Layout.fillWidth: true

            Text {
                text: notifSender + (notifChannel !== "" ? " — " + notifChannel : "")
                color: mainTextColor
                font.family: custom_font.name
                font.pixelSize: bubbleHeight * 17/60
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: notifBody
                color: fadedTextColor
                font.family: custom_font.name
                font.pixelSize: bubbleHeight * 13/60
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (!dismissAnim.running) dismissAnim.start()
        }
    }
}