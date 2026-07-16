import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import ".."

RowLayout {
    id: sysTrayRow
    spacing: 6
    implicitHeight: 22
    property string batteryText: ""

    Process {
        id: batteryBarQuery
        command: ["sh", "-lc", "bat=$(find /sys/class/power_supply -maxdepth 1 -name 'BAT*' -print -quit); [ -n \"$bat\" ] && printf '%s%%' \"$(cat \"$bat/capacity\" 2>/dev/null)\""]
        running: false
        stdout: StdioCollector { onStreamFinished: sysTrayRow.batteryText = text.trim() }
    }

    Timer {
        interval: 30000
        running: Config.settings.bar.showBatteryIndicator
        repeat: true
        triggeredOnStart: true
        onTriggered: if (!batteryBarQuery.running) batteryBarQuery.running = true
    }

    Text {
        visible: Config.settings.bar.showBatteryIndicator && sysTrayRow.batteryText.length > 0
        text: sysTrayRow.batteryText
        color: Config.settings.bar.textColor
        font.family: fontMonaco.name
        font.pixelSize: 9
        verticalAlignment: Text.AlignVCenter
        Layout.preferredHeight: 26
    }

    Item {
        visible: Config.settings.extras.notifications
        Layout.preferredWidth: 24
        Layout.preferredHeight: 26

        Text {
            anchors.centerIn: parent
            text: "\ue7f4"
            color: Config.notificationCount > 0 ? Config.colors.accent : Config.settings.bar.textColor
            font.family: "Material Symbols Sharp Filled 36pt"
            font.pixelSize: 14
        }

        Rectangle {
            visible: Config.notificationCount > 0
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 2
            width: 6
            height: 6
            radius: 3
            color: Config.colors.danger
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: Config.openNotificationCenter = !Config.openNotificationCenter
        }
    }

    ClockWidget {
        id: clockWidget
    }

    WheelHandler {
        enabled: Config.settings.bar.scrollVolume
        onWheel: event => {
            const step = event.angleDelta.y > 0 ? 0.03 : -0.03;
            AudioSystem.volume = Math.max(0, Math.min(1, AudioSystem.volume + step));
            event.accepted = true;
        }
    }
}
