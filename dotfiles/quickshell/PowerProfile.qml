import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: powerRoot
    color: secondaryColor
    radius: buttonRadius
    height: buttonHeight
    width: buttonHeight

    Layout.alignment: Qt.AlignTop
    Layout.topMargin: buttonTopMargin

    property string currentProfile: "balanced"

    function getIcon() {
        if (currentProfile === "performance") return "󱐋";
        if (currentProfile === "power-saver") return "";
        return "";
    }

    Text {
        anchors.centerIn: parent
        text: powerRoot.getIcon()
        color: mainColor
        font.pixelSize: 20
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            let nextProfile = "balanced";
            if (powerRoot.currentProfile === "balanced") nextProfile = "power-saver";
            else if (powerRoot.currentProfile === "power-saver") nextProfile = "performance";
            else if (powerRoot.currentProfile === "performance") nextProfile = "balanced";

            setProfileCmd.command = ["powerprofilesctl", "set", nextProfile];
            setProfileCmd.running = true;

            powerRoot.currentProfile = nextProfile;
        }
    }

    Process {
        id: fetchProfileCmd
        command: ["powerprofilesctl", "get"]
        stdout: SplitParser {
            onRead: (line) => {
                let profile = line.trim();
                if (profile !== "") {
                    powerRoot.currentProfile = profile;
                }
            }
        }
    }
    Process {
        id: setProfileCmd
    }

    Timer {
        interval: 5001
        running: true
        repeat: true
        onTriggered: fetchProfileCmd.running = true
        Component.onCompleted: fetchProfileCmd.running = true
    }
}