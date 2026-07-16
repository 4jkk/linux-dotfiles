import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import ".."

PanelWindow {
    id: root

    screen: Config.controlCenterScreen || Quickshell.screens[0]
    visible: osdVisible && Config.settings.extras.volumeOsd
    implicitWidth: 230
    implicitHeight: 48
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.namespace: "desktop-shell:volume-osd"

    anchors.bottom: true
    margins.bottom: 42

    property bool osdVisible: false
    property bool ready: false

    function reveal() {
        if (!ready || !Config.settings.extras.volumeOsd)
            return;
        osdVisible = true;
        hideTimer.restart();
    }

    Component.onCompleted: readyTimer.start()

    Timer {
        id: readyTimer
        interval: 800
        onTriggered: root.ready = true
    }

    Timer {
        id: hideTimer
        interval: 1300
        onTriggered: root.osdVisible = false
    }

    Connections {
        target: AudioSystem
        function onVolumeChanged() { root.reveal(); }
        function onMutedChanged() { root.reveal(); }
    }

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Config.colors.shadow
        border.width: 1
        border.color: Config.settings.ui.shellOutlineColor

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 14
            spacing: 10

            Text {
                Layout.preferredWidth: 24
                text: AudioSystem.muted ? "\ue04f" : "\ue050"
                color: AudioSystem.muted ? Config.colors.danger : Config.colors.accent
                font.family: "Material Symbols Sharp Filled 36pt"
                font.pixelSize: 19
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 4
                radius: 2
                color: Config.colors.highlight

                Rectangle {
                    width: parent.width * Math.max(0, Math.min(1, AudioSystem.volume))
                    height: parent.height
                    radius: parent.radius
                    color: AudioSystem.muted ? Config.colors.accentDark : Config.colors.accent
                }
            }

            Text {
                Layout.preferredWidth: 34
                text: Math.round(AudioSystem.volume * 100) + "%"
                color: Config.colors.textLight
                font.family: "Monaco"
                font.pixelSize: 9
                horizontalAlignment: Text.AlignRight
            }
        }
    }
}
