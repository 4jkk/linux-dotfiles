import QtQuick
import Quickshell
import ".."

Item {
    id: root

    implicitWidth: clockText.implicitWidth + 8
    height: 26

    Text {
        id: clockText
        anchors.fill: parent
        text: Time.time
        color: Config.settings.bar.textColor
        font.pixelSize: 12
        font.family: fontMonaco.name
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        opacity: clockMouse.containsMouse || Config.openCalendar ? 1 : 0.88
    }

    MouseArea {
        id: clockMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Config.calendarScreen = taskbar.screen;
            Config.openControlCenter = false;
            Config.openCalendar = !Config.openCalendar;
        }
    }
}
