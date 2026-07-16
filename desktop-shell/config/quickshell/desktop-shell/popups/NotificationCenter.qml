import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import ".."

PanelWindow {
    id: root

    screen: Config.controlCenterScreen || Quickshell.screens[0]
    visible: Config.openNotificationCenter
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.namespace: "desktop-shell:notifications"

    anchors { left: true; top: true; right: true; bottom: true }

    function updateCount() {
        Config.notificationCount = notificationServer.trackedNotifications.count;
    }

    NotificationServer {
        id: notificationServer
        bodySupported: true
        imageSupported: true
        actionsSupported: true
        persistenceSupported: true
        keepOnReload: true

        onNotification: notification => {
            notification.tracked = true;
            Qt.callLater(root.updateCount);
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.updateCount()
    }

    MouseArea { anchors.fill: parent; onClicked: Config.openNotificationCenter = false }
    Shortcut { sequence: "Escape"; enabled: root.visible; onActivated: Config.openNotificationCenter = false }

    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: Config.settings.bar.offset + Config.settings.bar.height + 6
        x: Math.max(12, (parent.width + parent.width * (Config.settings.bar.layoutMode === "full" ? 1 : Config.settings.bar.widthPercent / 100)) / 2 - width)
        width: Math.min(350, parent.width - 24)
        height: Math.min(430, parent.height - anchors.topMargin - 12)
        radius: 12
        color: Config.colors.shadow
        border.width: 1
        border.color: Config.settings.ui.shellOutlineColor
        clip: true

        MouseArea { anchors.fill: parent; onClicked: {} }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 32

                Text {
                    Layout.fillWidth: true
                    text: "Notifications"
                    color: Config.colors.accent
                    font.family: "Recia"
                    font.pixelSize: 17
                    font.bold: true
                }

                Text {
                    text: notificationServer.trackedNotifications.count
                    color: Config.colors.textLight
                    font.family: "Monaco"
                    font.pixelSize: 10
                }
            }

            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: notificationServer.trackedNotifications.count === 0
                text: "Nothing new"
                color: Qt.darker(Config.colors.textLight, 1.25)
                font.family: "Monaco"
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: notificationServer.trackedNotifications.count > 0
                model: notificationServer.trackedNotifications
                spacing: 7
                clip: true

                delegate: Rectangle {
                    required property var modelData
                    width: ListView.view.width
                    height: 72
                    radius: 10
                    color: notificationMouse.containsMouse ? Config.colors.highlight : Config.colors.base
                    border.width: 1
                    border.color: Config.colors.outline

                    Column {
                        anchors.left: parent.left
                        anchors.right: closeButton.left
                        anchors.top: parent.top
                        anchors.margins: 10
                        spacing: 4

                        Text {
                            width: parent.width
                            text: modelData.summary || modelData.appName || "Notification"
                            color: Config.colors.textLight
                            font.family: "Monaco"
                            font.pixelSize: 11
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        Text {
                            width: parent.width
                            text: modelData.body || modelData.appName || ""
                            color: Qt.darker(Config.colors.textLight, 1.15)
                            font.family: "Monaco"
                            font.pixelSize: 9
                            textFormat: Text.PlainText
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            wrapMode: Text.Wrap
                        }
                    }

                    Text {
                        id: closeButton
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: 9
                        width: 22
                        height: 22
                        text: "×"
                        color: Config.colors.textLight
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                modelData.dismiss();
                                Qt.callLater(root.updateCount);
                            }
                        }
                    }

                    MouseArea { id: notificationMouse; anchors.fill: parent; acceptedButtons: Qt.NoButton; hoverEnabled: true }
                }
            }
        }
    }
}
