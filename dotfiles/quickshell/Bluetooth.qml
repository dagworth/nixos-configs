import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Bluetooth

Rectangle {
    id: bluetoothButton
    color: active ? mainColor : secondaryColor
    Layout.preferredHeight: buttonHeight
    Layout.preferredWidth: buttonHeight
    radius: buttonRadius

    Layout.alignment: Qt.AlignTop
    Layout.topMargin: buttonTopMargin

    property bool active: rootBar.openPopupId === "bluetooth"
    property bool discover_view: false
    property string searchText: ""

    property var filteredDevices: {
        if (!Bluetooth.defaultAdapter) return [];
        var query = searchText.toLowerCase();
        var all = Bluetooth.defaultAdapter.devices.values;
        var result = [];
        for (var i = 0; i < all.length; i++) {
            var d = all[i];
            var matchesTab = discover_view ? !d.paired : d.paired;
            if (!matchesTab) continue;
            if (query !== "") {
                var name = d.name ? d.name.toLowerCase() : "";
                var address = d.address ? d.address.toLowerCase() : "";
                if (name.indexOf(query) === -1 && address.indexOf(query) === -1) continue;
            }
            result.push(d);
        }
        return result;
    }

    onActiveChanged: focusGrab.active = active

    HyprlandFocusGrab {
        id: focusGrab
        windows: [rootBar, popup]
        onCleared: {
            if (rootBar.openPopupId === "bluetooth") rootBar.openPopupId = ""
        }
    }

    Text {
        anchors.centerIn: parent
        text: {
            if(Bluetooth.defaultAdapter) {
                return Bluetooth.defaultAdapter.enabled ? "󰂯" : "󰂲"
            } else {
                return ":("
            }
        }
        color: active ? darkColor : mainColor
        font.family: custom_font.name
        font.pixelSize: buttonHeight*32/45
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            rootBar.openPopupId = active ? "" : "bluetooth"
        }
    }

    PopupWindow {
        id: popup
        implicitHeight: 450
        implicitWidth: 350
        color: "transparent"
        visible: active

        anchor {
            window: rootBar
            item: bluetoothButton
            rect.y: bluetoothButton.y + bluetoothButton.height + 5
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
                        text: "bluetooth"
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 24
                        color: mainColor
                        radius: 12

                        Text {
                            anchors.centerIn: parent
                            text: (Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled) ? "On" : "Off"
                            color: mainTextColor
                            font.pixelSize: 11
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled;
                            }
                        }
                    }
                }

                // tab buttons
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    visible: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled

                    //paired
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30
                        radius: 6
                        color: !bluetoothButton.discover_view ? mainColor : backgroundColor

                        Text {
                            anchors.centerIn: parent
                            text: "paired devices"
                            color: mainTextColor
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                bluetoothButton.discover_view = false;
                                Bluetooth.defaultAdapter.discovering = false;
                            }
                        }
                    }

                    //pair new
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30
                        radius: 6
                        color: bluetoothButton.discover_view ? mainColor : backgroundColor

                        Text {
                            anchors.centerIn: parent
                            text: "pair new device"
                            color: mainTextColor
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                bluetoothButton.discover_view = true;
                                Bluetooth.defaultAdapter.discovering = true;
                            }
                        }
                    }
                }

                // search bar
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 30
                    color: backgroundColor
                    radius: 6
                    visible: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        text: "search devices"
                        color: fadedTextColor
                        font.pixelSize: 13
                        visible: searchInput.text.length === 0
                    }

                    TextInput {
                        id: searchInput
                        anchors.fill: parent
                        anchors.margins: 6
                        color: mainTextColor
                        font.pixelSize: 13
                        clip: true

                        onTextChanged: bluetoothButton.searchText = text
                    }
                }

                // device list
                ListView {
                    id: deviceListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 5

                    visible: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled

                    model: bluetoothButton.filteredDevices

                    delegate: Rectangle {
                        width: deviceListView.width
                        height: 45

                        color: backgroundColor
                        radius: 6

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                //name
                                Text {
                                    text: (modelData && modelData.name !== "") ? modelData.name : "unknown device"
                                    color: mainTextColor
                                    font.pixelSize: 14
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }

                                //mac
                                Text {
                                    text: modelData ? modelData.address : ""
                                    color: fadedTextColor
                                    font.pixelSize: 11
                                    Layout.fillWidth: true
                                }
                            }

                            Text {
                                text: (modelData && modelData.connected) ? "Connected" : ""
                                color: mainColor
                                font.pixelSize: 12
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (modelData) {
                                    if (modelData.connected) {
                                        modelData.disconnect();
                                    } else {
                                        modelData.connect();
                                    }
                                }
                            }
                        }
                    }
                }

                //fallback if bluetooth is off
                Text {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    visible: !Bluetooth.defaultAdapter || !Bluetooth.defaultAdapter.enabled

                    text: "bluetooth is off"
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