import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import ".."
import "../utils/" as Utils

RowLayout {
    id: workspaces
    spacing: 0
    implicitHeight: 22

    property var currentWorkspaces: []

    function normalizeWorkspaces(payload) {
        let parsed = [];

        function pushWorkspace(entry, fallbackIndex) {
            if (!entry || typeof entry !== "object" || Array.isArray(entry)) {
                return;
            }

            const rawIndex = entry.idx ?? entry.index;
            const index = rawIndex !== undefined && rawIndex !== null ? Number(rawIndex) : Number(fallbackIndex);
            if (!Number.isFinite(index) || index <= 0) {
                return;
            }

            parsed.push({
                idx: index,
                name: entry.name ?? entry.title ?? "",
                active: Boolean(entry.is_focused ?? entry.focused ?? entry.active ?? false),
            });
        }

        function walk(node, fallbackIndex) {
            if (!node) {
                return;
            }
            if (Array.isArray(node)) {
                node.forEach((child, i) => walk(child, i + 1));
                return;
            }
            if (typeof node !== "object") {
                return;
            }

            pushWorkspace(node, fallbackIndex);

            for (const key in node) {
                const child = node[key];
                if (Array.isArray(child)) {
                    child.forEach((entry, i) => walk(entry, i + 1));
                }
            }
        }

        let data = null;
        try {
            data = JSON.parse(payload);
        } catch (error) {
            return [];
        }

        if (data && data.Ok) {
            data = data.Ok;
        }
        if (data && data.Workspaces) {
            data = data.Workspaces;
        }
        if (data && data.workspaces) {
            data = data.workspaces;
        }
        if (data && data.items) {
            data = data.items;
        }

        if (Array.isArray(data)) {
            data.forEach((entry, index) => pushWorkspace(entry, index + 1));
        } else {
            walk(data, 1);
        }

        parsed.sort((a, b) => a.idx - b.idx);

        const deduped = [];
        const seen = {};
        for (const item of parsed) {
            if (!seen[item.idx]) {
                seen[item.idx] = true;
                deduped.push(item);
            }
        }

        return deduped;
    }

    function refreshWorkspaces() {
        if (!workspaceQuery.running) {
            workspaceQuery.running = true;
        }
    }

    Component.onCompleted: refreshWorkspaces()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: workspaces.refreshWorkspaces()
    }

    Process {
        id: workspaceQuery
        command: ["sh", "-c", "if [ -n \"${HYPRLAND_INSTANCE_SIGNATURE:-}\" ]; then active=$(hyprctl activeworkspace -j | jq -r '.id'); hyprctl workspaces -j | jq --argjson active \"$active\" 'map({idx: .id, name: .name, active: (.id == $active)})'; else niri msg -j workspaces; fi"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const entries = workspaces.normalizeWorkspaces(text);
                if (entries.length > 0) {
                    workspaces.currentWorkspaces = entries;
                }
            }
        }
    }

    Repeater {
        model: workspaces.currentWorkspaces
        Button {
            id: control
            implicitWidth: 21
            implicitHeight: 26
            scale: mouse.hovered ? 1.08 : 1

            Behavior on scale {
                enabled: !Config.settings.bar.reduceMotion
                NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
            }

            contentItem: Text {
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: Utils.TextUtils.toRomanNumeral(modelData.idx)
                font.family: fontGgSans.name
                font.weight: Font.Medium
                font.pixelSize: 14
                color: modelData.active ? Config.colors.accent
                                        : (mouse.hovered ? Config.settings.bar.textColor : Qt.darker(Config.settings.bar.textColor, 1.35))
            }

            onPressed: event => {
                const workspaceRef = modelData.name && modelData.name.length > 0 ? modelData.name : String(modelData.idx);
                Quickshell.execDetached(["sh", "-c", "if [ -n \"${HYPRLAND_INSTANCE_SIGNATURE:-}\" ]; then hyprctl dispatch workspace \"$1\"; else niri msg action focus-workspace \"$1\"; fi", "desktop-shell", workspaceRef]);
                event.accepted = true;
            }

            property int focusedWorkspaceId: 0

            background: Rectangle {
                anchors.fill: parent
                border.width: 0
                color: "transparent"
            }

            HoverHandler {
                id: mouse
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                cursorShape: Qt.PointingHandCursor
            }
        }
    }
}
