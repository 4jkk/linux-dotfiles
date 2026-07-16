import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import ".."

PanelWindow {
    id: root

    screen: Config.calendarScreen || Quickshell.screens[0]
    visible: Config.openCalendar
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.namespace: "desktop-shell:calendar"

    anchors {
        left: true
        top: true
        right: true
        bottom: true
    }

    property date today: new Date()
    property int viewYear: today.getFullYear()
    property int viewMonth: today.getMonth()
    readonly property color panelColor: Config.colors.shadow || "#121212"
    readonly property color surfaceColor: Config.colors.base || "#181818"
    readonly property color raisedColor: Config.colors.highlight || "#333333"
    readonly property color outlineColor: Config.colors.accentDark || "#87704f"
    readonly property color textColor: Config.colors.textLight || "#d0daed"
    readonly property color accentColor: Config.colors.accent || "#fccf8a"
    readonly property color shellOutlineColor: Config.settings.ui.shellOutlineColor || "#ff0000"
    readonly property var weekdayNames: ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]

    function firstWeekday() {
        const sundayBased = new Date(viewYear, viewMonth, 1).getDay();
        return (sundayBased + 6) % 7;
    }

    function daysInMonth() {
        return new Date(viewYear, viewMonth + 1, 0).getDate();
    }

    function dayForCell(index) {
        const day = index - firstWeekday() + 1;
        return day >= 1 && day <= daysInMonth() ? day : 0;
    }

    function isToday(day) {
        return day > 0 && viewYear === today.getFullYear()
            && viewMonth === today.getMonth() && day === today.getDate();
    }

    function moveMonth(offset) {
        const next = new Date(viewYear, viewMonth + offset, 1);
        viewYear = next.getFullYear();
        viewMonth = next.getMonth();
    }

    function showToday() {
        today = new Date();
        viewYear = today.getFullYear();
        viewMonth = today.getMonth();
    }

    Timer {
        interval: 60000
        running: root.visible
        repeat: true
        triggeredOnStart: true
        onTriggered: root.today = new Date()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Config.openCalendar = false
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.visible
        onActivated: Config.openCalendar = false
    }

    Rectangle {
        id: calendarPanel

        anchors.top: parent.top
        anchors.topMargin: Config.settings.bar.offset + Config.settings.bar.height + 6
        x: Math.max(12, (parent.width + parent.width * (Config.settings.bar.layoutMode === "full" ? 1 : Config.settings.bar.widthPercent / 100)) / 2 - width)
        width: Math.min(292, parent.width - 24)
        height: 310
        radius: 10
        color: root.panelColor
        border.width: 1
        border.color: root.shellOutlineColor

        MouseArea { anchors.fill: parent; onClicked: {} }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 6

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                spacing: 6

                CalendarButton { icon: "‹"; tooltip: "Previous month"; onClicked: root.moveMonth(-1) }

                Text {
                    Layout.fillWidth: true
                    text: Qt.formatDate(new Date(root.viewYear, root.viewMonth, 1), "MMMM yyyy")
                    color: root.textColor
                    font.family: fontRecia.name
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                    horizontalAlignment: Text.AlignHCenter
                }

                CalendarButton { icon: "›"; tooltip: "Next month"; onClicked: root.moveMonth(1) }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 7
                columnSpacing: 3
                rowSpacing: 3

                Repeater {
                    model: root.weekdayNames

                    Text {
                        required property string modelData
                        Layout.fillWidth: true
                        Layout.preferredHeight: 18
                        text: modelData
                        color: Qt.darker(root.textColor, 1.35)
                        font.family: fontMonaco.name
                        font.pixelSize: 8
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Repeater {
                    model: 42

                    Rectangle {
                        required property int index
                        readonly property int dayNumber: root.dayForCell(index)
                        Layout.fillWidth: true
                        Layout.preferredHeight: 29
                        radius: 7
                        color: root.isToday(dayNumber) ? root.accentColor
                              : (dayMouse.containsMouse && dayNumber > 0 ? root.raisedColor : "transparent")
                        border.width: root.isToday(dayNumber) ? 1 : 0
                        border.color: root.accentColor

                        Text {
                            anchors.centerIn: parent
                            text: parent.dayNumber > 0 ? parent.dayNumber : ""
                            color: root.isToday(parent.dayNumber) ? root.panelColor : root.textColor
                            font.family: fontMonaco.name
                            font.pixelSize: 10
                            font.bold: root.isToday(parent.dayNumber)
                        }

                        MouseArea {
                            id: dayMouse
                            anchors.fill: parent
                            enabled: parent.dayNumber > 0
                            hoverEnabled: true
                            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                radius: 7
                color: todayMouse.containsMouse ? root.raisedColor : "transparent"
                border.width: 0

                Text {
                    anchors.centerIn: parent
                    text: "Today  ·  " + Qt.formatDate(root.today, "dddd, d MMMM")
                    color: root.textColor
                    font.family: fontRecia.name
                    font.pixelSize: 10
                }

                MouseArea {
                    id: todayMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.showToday()
                }
            }
        }
    }

    component CalendarButton: Rectangle {
        id: button
        property string icon
        property string tooltip
        signal clicked()

        Layout.preferredWidth: 30
        Layout.preferredHeight: 30
        radius: 7
        color: buttonMouse.containsMouse ? root.raisedColor : "transparent"
        border.width: 0

        Text {
            anchors.centerIn: parent
            text: button.icon
            color: root.textColor
            font.pixelSize: 20
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            id: buttonMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: button.clicked()
        }
    }
}
