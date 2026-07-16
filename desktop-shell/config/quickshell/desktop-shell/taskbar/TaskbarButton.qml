import Quickshell
import QtQuick
import QtQuick.Controls.Basic

import ".."

Button {
    id: root

    property bool isToggled: false
    property string iconFontValue: "\ue5c3"
    property string toggledIconFontValue: "\ue5c5"
    property string iconFontFamily: "Material Symbols Sharp Filled 36pt"
    property real iconHorizontalOffset: 0
    property real iconVerticalOffset: 0

    implicitWidth: 26
    implicitHeight: 26
    scale: mouse.hovered ? 1.06 : 1

    Behavior on scale {
        enabled: !Config.settings.bar.reduceMotion
        NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
    }

    contentItem: Text {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: root.iconFontFamily
        font.pixelSize: root.isToggled ? 20 : 18
        text: root.isToggled ? root.toggledIconFontValue : root.iconFontValue
        color: Config.settings.bar.textColor
        transform: Translate {
            x: root.iconHorizontalOffset
            y: root.iconVerticalOffset
        }
    }

    background: Rectangle {
        anchors.fill: parent
        border.width: 1
        border.color: root.isToggled ? Config.colors.accent : Config.colors.highlight
        color: mouse.hovered || root.isToggled ? Qt.rgba(0, 0, 0, 0.18) : "transparent"
        radius: 0
    }
    HoverHandler {
        id: mouse
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        cursorShape: Qt.PointingHandCursor
    }
}
