import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: battery

    Layout.preferredHeight: buttonHeight*50/45
    Layout.preferredWidth: buttonHeight*40/45

    Layout.alignment: Qt.AlignVCenter

    property string currentBat: "100"
    property real numberOffsetX: 0
    property real numberOffsetY: buttonHeight*50/45*0.18
    property real iconOffsetY: -buttonHeight*0.06

    FileView {
        id: batteryFile
        path: "/sys/class/power_supply/BAT0/capacity"
    }

    Text {
        id: batteryIcon
        anchors.centerIn: parent
        anchors.verticalCenterOffset: battery.iconOffsetY
        text: "󰂀"
        color: {
            if(battery.currentBat >= 20) {
                return mainColor
            } else {
                return "red"
            }
        }
        font.family: custom_font.name
        font.pixelSize: buttonHeight*50/45
    }

    Text {
        id: batteryNumber
        anchors.centerIn: batteryIcon
        anchors.horizontalCenterOffset: battery.numberOffsetX
        anchors.verticalCenterOffset: battery.numberOffsetY
        text: {
            if(battery.currentBat == 100) {
                return "󰋑"
            } else {
                return battery.currentBat
            }
        }
        color: darkColor
        font.family: custom_font.name
        font.pixelSize: buttonHeight*16/45
        font.bold: true
    }

    Process {
        id: checker
        command: ["cat", "/sys/class/power_supply/BAT0/capacity"]
        stdout: SplitParser {
            onRead: (line) => {
                if (line.trim() !== "") {
                    battery.currentBat = line.trim();
                }
            }
        }
    }

    Timer {
        interval: 15002
        running: true
        repeat: true
        onTriggered: checker.running = true
        Component.onCompleted: checker.running = true
    }
}
