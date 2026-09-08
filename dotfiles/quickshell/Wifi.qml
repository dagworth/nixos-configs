import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Networking

Rectangle {
    id: wifiButton
    color: active ? mainColor : secondaryColor
    Layout.preferredHeight: buttonHeight
    Layout.preferredWidth: buttonHeight
    radius: buttonRadius

    Layout.alignment: Qt.AlignTop
    Layout.topMargin: buttonTopMargin

    property bool active: rootBar.openPopupId === "wifi"
    property var expandedNetwork: null

    property var wifiDevice: {
        if (!Networking.devices) return null
        let devices = Networking.devices.values
        for (let i = 0; i < devices.length; i++) {
            if (devices[i].type === DeviceType.Wifi) return devices[i]
        }
        return null
    }

    property var connectedNetwork: {
        if (!wifiDevice || !wifiDevice.networks) return null
        let nets = wifiDevice.networks.values
        for (let i = 0; i < nets.length; i++) {
            if (nets[i].connected) return nets[i]
        }
        return null
    }

    function strengthIcon(strength) {
        if (strength >= 0.75) return "󰤨"
        if (strength >= 0.50) return "󰤥"
        if (strength >= 0.25) return "󰤢"
        return "󰤟"
    }

    onActiveChanged: {
        focusGrab.active = active
        if (wifiDevice) wifiDevice.scannerEnabled = active
        if (!active) expandedNetwork = null
    }

    HyprlandFocusGrab {
        id: focusGrab
        windows: [rootBar, popup]
        onCleared: {
            if (rootBar.openPopupId === "wifi") rootBar.openPopupId = ""
        }
    }

    Text {
        anchors.centerIn: parent
        text: {
            if (!wifiButton.wifiDevice) return ":("
            if (!Networking.wifiEnabled) return "󰤭"
            if (wifiButton.connectedNetwork) return wifiButton.strengthIcon(wifiButton.connectedNetwork.signalStrength)
            return "󰤫"
        }
        color: active ? darkColor : mainColor
        font.family: custom_font.name
        font.pixelSize: buttonHeight*32/45
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            rootBar.openPopupId = wifiButton.active ? "" : "wifi"
        }
    }

    PopupWindow {
        id: popup
        implicitHeight: 450
        implicitWidth: 350
        color: "transparent"
        visible: wifiButton.active

        anchor {
            window: rootBar
            item: wifiButton
            rect.y: wifiButton.y + wifiButton.height + 5
        }

        Rectangle {
            anchors.fill: parent
            opacity: popup.visible ? 1 : 0
            color: secondaryColor
            radius: buttonHeight

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 15

                //toggle on off
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        color: mainTextColor
                        font.pixelSize: 16
                        font.bold: true
                        font.family: custom_font.name
                        text: "wifi"
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 24
                        color: mainColor
                        radius: 12

                        Text {
                            anchors.centerIn: parent
                            text: Networking.wifiEnabled ? "On" : "Off"
                            color: mainTextColor
                            font.pixelSize: 11
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Networking.wifiEnabled = !Networking.wifiEnabled;
                            }
                        }
                    }
                }

                // network list
                ListView {
                    id: networkListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 5

                    visible: Networking.wifiEnabled && wifiButton.wifiDevice

                    model: wifiButton.wifiDevice ? wifiButton.wifiDevice.networks : null

                    delegate: Rectangle {
                        id: networkDelegate
                        width: networkListView.width
                        property bool expanded: wifiButton.expandedNetwork === modelData

                        onExpandedChanged: {
                            if (expanded) pskInput.forceActiveFocus()
                        }

                        height: expanded ? 90 : 45
                        color: backgroundColor
                        radius: 6

                        Behavior on height {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutCubic
                            }
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 8

                            Item {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 25

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 8

                                    Text {
                                        text: (modelData && modelData.security !== WifiSecurityType.Open) ? "󰌾" : ""
                                        color: fadedTextColor
                                        font.family: custom_font.name
                                        font.pixelSize: 12
                                    }

                                    Text {
                                        text: (modelData && modelData.name !== "") ? modelData.name : "unknown network"
                                        color: mainTextColor
                                        font.pixelSize: 14
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        text: (modelData && modelData.connected) ? "Connected" : ""
                                        color: mainColor
                                        font.pixelSize: 12
                                    }

                                    Text {
                                        text: modelData ? wifiButton.strengthIcon(modelData.signalStrength) : ""
                                        color: mainColor
                                        font.family: custom_font.name
                                        font.pixelSize: 14
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (!modelData) return;
                                        if (modelData.connected) {
                                            modelData.disconnect();
                                        } else if (modelData.security !== WifiSecurityType.Open && !modelData.known) {
                                            wifiButton.expandedNetwork = networkDelegate.expanded ? null : modelData;
                                        } else {
                                            modelData.connect();
                                        }
                                    }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                visible: networkDelegate.expanded
                                spacing: 8

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 30
                                    color: backgroundColor
                                    radius: 6

                                    TextInput {
                                        id: pskInput
                                        anchors.fill: parent
                                        anchors.margins: 6
                                        color: mainTextColor
                                        font.pixelSize: 13
                                        echoMode: TextInput.Password
                                        clip: true
                                        focus: networkDelegate.expanded

                                        Keys.onReturnPressed: {
                                            if (modelData) modelData.connectWithPsk(pskInput.text);
                                            wifiButton.expandedNetwork = null;
                                        }
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 70
                                    Layout.preferredHeight: 30
                                    radius: 6
                                    color: mainColor

                                    Text {
                                        anchors.centerIn: parent
                                        text: "connect"
                                        color: darkColor
                                        font.pixelSize: 12
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (modelData) modelData.connectWithPsk(pskInput.text);
                                            wifiButton.expandedNetwork = null;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                //fallback if wifi is off / no adapter
                Text {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    visible: !wifiButton.wifiDevice || !Networking.wifiEnabled

                    text: !wifiButton.wifiDevice ? "no wifi adapter" : "wifi is off"
                    color: fadedTextColor
                    font.family: custom_font.name
                    font.pixelSize: 30

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
