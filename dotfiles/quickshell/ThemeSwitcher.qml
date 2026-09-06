import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: themeButton
    color: popupOpen ? mainColor : secondaryColor
    radius: buttonRadius
    height: buttonHeight
    width: buttonHeight

    Layout.alignment: Qt.AlignTop
    Layout.topMargin: buttonTopMargin

    property bool popupOpen: false
    property string currentTheme: "main"
    property string currentWallpaper: ""

    property var themes: [
        {
            name: "main",
            backgroundColor: "#99343434",
            mainTextColor: "#cdd6f4",
            fadedTextColor: "#9ca6adc8",
            mainColor: "#5daca2",
            secondaryColor: "#2f5550",
            darkColor: "#0c2930",
            wallpaper: Quickshell.env("HOME") + "/.config/hypr/main.jpg"
        },
        {
            name: "purple",
            backgroundColor: '#99242424',
            mainTextColor: '#cecece',
            fadedTextColor: '#9c9195b1',
            mainColor: '#991799',
            secondaryColor: '#4c054c',
            darkColor: '#0c2930',
            wallpaper: Quickshell.env("HOME") + "/.config/hypr/secondary.jpg"
        }
    ]

    function findTheme(name) {
        for (let i = 0; i < themes.length; i++) {
            if (themes[i].name === name) return themes[i]
        }
        return null
    }

    function applyTheme(theme, persist) {
        if (!theme) return

        let oldWallpaper = currentWallpaper

        backgroundColor = theme.backgroundColor
        mainTextColor   = theme.mainTextColor
        fadedTextColor  = theme.fadedTextColor
        mainColor       = theme.mainColor
        secondaryColor  = theme.secondaryColor
        darkColor       = theme.darkColor

        currentTheme     = theme.name
        currentWallpaper = theme.wallpaper

        let cmd = "hyprctl hyprpaper preload '" + theme.wallpaper + "'"
                + " && hyprctl hyprpaper wallpaper '," + theme.wallpaper + "'"
        if (oldWallpaper !== "" && oldWallpaper !== theme.wallpaper) {
            cmd += " && hyprctl hyprpaper unload '" + oldWallpaper + "'"
        }
        wallpaperProc.command = ["bash", "-c", cmd]
        wallpaperProc.running = true

        if (persist !== false) {
            themeFile.setText(theme.name)
        }

        popupOpen = false
    }

    Process {
        id: wallpaperProc
    }

    FileView {
        id: themeFile
        path: Quickshell.env("HOME") + "/.cache/quickshell/theme"
        printErrors: false
    }

    Component.onCompleted: {
        let saved = themeFile.text().trim()
        applyTheme(findTheme(saved) || themes[0], false)
    }

    Text {
        anchors.centerIn: parent
        text: "󰏘"
        color: popupOpen ? darkColor : mainColor
        font.family: custom_font.name
        font.pixelSize: buttonHeight*32/45
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: themeButton.popupOpen = !themeButton.popupOpen
    }

    PopupWindow {
        id: popup
        implicitWidth: 200
        implicitHeight: themeButton.themes.length * 42 + 24
        color: "transparent"
        visible: themeButton.popupOpen

        anchor {
            window: rootBar
            item: themeButton
            rect.y: themeButton.y + themeButton.height + 5
        }

        Rectangle {
            anchors.fill: parent
            color: secondaryColor
            radius: buttonRadius

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Repeater {
                    model: themeButton.themes

                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 34
                        radius: 6
                        color: modelData.name === themeButton.currentTheme ? mainColor : backgroundColor

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 8

                            Rectangle {
                                Layout.preferredWidth: 14
                                Layout.preferredHeight: 14
                                radius: 7
                                color: modelData.mainColor
                            }

                            Text {
                                text: modelData.name
                                color: mainTextColor
                                font.family: custom_font.name
                                font.pixelSize: 14
                                Layout.fillWidth: true
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: themeButton.applyTheme(modelData)
                        }
                    }
                }
            }
        }
    }
}
