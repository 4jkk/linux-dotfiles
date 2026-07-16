import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

import ".."

Scope {
    // Taskbar variants, we have one taskber per screen.
    Variants {
        model: Quickshell.screens
        Item {
            id: root
            required property var modelData
            property string activeWindowTitle: ""

            function refreshActiveWindow() {
                if (Config.settings.bar.showActiveWindow && !activeWindowQuery.running)
                    activeWindowQuery.running = true;
            }

            Process {
                id: activeWindowQuery
                command: ["sh", "-c", "if [ -n \"${HYPRLAND_INSTANCE_SIGNATURE:-}\" ]; then hyprctl activewindow -j; else niri msg -j focused-window; fi"]
                running: false
                stdout: StdioCollector {
                    onStreamFinished: {
                        try {
                            const value = JSON.parse(text);
                            const windowData = value.Ok || value;
                            root.activeWindowTitle = windowData && windowData.title ? windowData.title : "";
                        } catch (error) {
                            root.activeWindowTitle = "";
                        }
                    }
                }
            }

            Timer {
                interval: 1500
                running: Config.settings.bar.showActiveWindow
                repeat: true
                triggeredOnStart: true
                onTriggered: root.refreshActiveWindow()
            }

            PanelWindow {
                id: taskbar
                screen: root.modelData
                WlrLayershell.layer: WlrLayer.Bottom
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
                WlrLayershell.namespace: "desktop-shell:bars"

                anchors {
                    top: true
                    left: Config.settings.bar.layoutMode === "full"
                    right: Config.settings.bar.layoutMode === "full"
                }
                margins.top: Config.settings.bar.offset
                implicitWidth: Config.settings.bar.layoutMode === "full"
                               ? screen.width : screen.width * Config.settings.bar.widthPercent / 100
                implicitHeight: Config.settings.bar.height
                color: "transparent"
                /*=== Taskbar Background (colors & shading) ===*/
                Rectangle {
                    anchors.fill: parent
                    visible: Config.settings.bar.edgeStyle !== "goth-cut"
                    property color glassColor: Config.colors.base
                    color: Qt.rgba(glassColor.r, glassColor.g, glassColor.b,
                                   Config.settings.bar.smartTransparency ? Math.min(Config.settings.bar.opacity, 0.42) : Config.settings.bar.opacity)
                    border.width: 1
                    topLeftRadius: Config.settings.bar.edgeStyle === "square" ? 0 : Config.settings.bar.radius
                    topRightRadius: Config.settings.bar.edgeStyle === "square" ? 0 : Config.settings.bar.radius
                    bottomLeftRadius: Config.settings.bar.edgeStyle === "square" ? 0 : Config.settings.bar.radius
                    bottomRightRadius: Config.settings.bar.edgeStyle === "square" ? 0 : Config.settings.bar.radius
                    border.color: Config.colors.outline
                }

                Canvas {
                    id: gothBackground
                    anchors.fill: parent
                    visible: Config.settings.bar.edgeStyle === "goth-cut"
                    antialiasing: true

                    property color fillColor: {
                        const base = Config.colors.base;
                        const alpha = Config.settings.bar.smartTransparency
                                    ? Math.min(Config.settings.bar.opacity, 0.42) : Config.settings.bar.opacity;
                        return Qt.rgba(base.r, base.g, base.b, alpha);
                    }
                    property color strokeColor: Config.colors.outline
                    property real cutSize: Math.min(10, height * 0.36)

                    onFillColorChanged: requestPaint()
                    onStrokeColorChanged: requestPaint()
                    onCutSizeChanged: requestPaint()
                    onWidthChanged: requestPaint()
                    onHeightChanged: requestPaint()

                    onPaint: {
                        const context = getContext("2d");
                        const cut = cutSize;
                        context.clearRect(0, 0, width, height);
                        context.beginPath();
                        context.moveTo(cut, 0.5);
                        context.lineTo(width - cut, 0.5);
                        context.lineTo(width - 0.5, cut);
                        context.lineTo(width - 0.5, height - cut);
                        context.lineTo(width - cut, height - 0.5);
                        context.lineTo(cut, height - 0.5);
                        context.lineTo(0.5, height - cut);
                        context.lineTo(0.5, cut);
                        context.closePath();
                        context.fillStyle = fillColor;
                        context.fill();
                        context.strokeStyle = strokeColor;
                        context.lineWidth = 1;
                        context.stroke();
                    }
                }

                /*=== ===================================== ===*/

                /*=== Workspaces & Background for it ===*/
                Workspaces {
                    id: workspaces
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: Config.settings.bar.centerWorkspaces ? undefined : parent.left
                    anchors.leftMargin: Config.settings.bar.centerWorkspaces ? 0 : 12
                    anchors.horizontalCenter: Config.settings.bar.centerWorkspaces ? parent.horizontalCenter : undefined
                    width: Math.min(implicitWidth, taskbar.width * 0.36)
                    clip: true
                }
                /*=== ============================== ===*/
                TaskbarButton {
                    id: appLauncherButton
                    isToggled: Config.openControlCenter
                    iconFontFamily: Config.settings.bar.launcherIconFont
                    iconFontValue: Config.settings.bar.launcherIconGlyph
                    toggledIconFontValue: Config.settings.bar.launcherIconGlyph
                    iconHorizontalOffset: Config.settings.bar.launcherIconFont === "JetBrainsMono Nerd Font" ? -3 : 0
                    iconVerticalOffset: 1
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: Config.settings.bar.centerWorkspaces ? undefined : parent.horizontalCenter
                    anchors.left: Config.settings.bar.centerWorkspaces ? parent.left : undefined
                    anchors.leftMargin: Config.settings.bar.centerWorkspaces ? 12 : 0
                    onClicked: {
                        Config.controlCenterScreen = root.modelData;
                        Config.openControlCenter = !Config.openControlCenter;
                    }
                }

                Text {
                    anchors.left: Config.settings.bar.centerWorkspaces ? appLauncherButton.right : workspaces.right
                    anchors.leftMargin: 8
                    anchors.right: Config.settings.bar.centerWorkspaces ? workspaces.left : appLauncherButton.left
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    visible: Config.settings.bar.showActiveWindow && text.length > 0
                    text: root.activeWindowTitle
                    color: Qt.darker(Config.settings.bar.textColor, 1.16)
                    font.family: fontMonaco.name
                    font.pixelSize: 9
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }

                /*=== ============================= ===*/

                /*=== System Tray & Background for it ===*/
                SysTray {
                    id: sysTray
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    width: Math.min(implicitWidth, taskbar.width * 0.36)
                    clip: true
                }
                /*=== =============================== ===*/
            }
        }
    }
}
