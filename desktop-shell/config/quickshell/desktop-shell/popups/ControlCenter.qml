import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Dialogs
import QtQuick.Layouts
import Qt.labs.folderlistmodel

import ".."

PanelWindow {
    id: root

    screen: Config.controlCenterScreen || Quickshell.screens[0]

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.namespace: "desktop-shell:control-center"
    exclusionMode: ExclusionMode.Ignore

    anchors {
        left: true
        top: true
        right: true
        bottom: true
    }

    visible: Config.openControlCenter
    color: "transparent"

    property string identityName: "akk"
    property string identityHost: "fedora"
    property string uptimeText: "up --"
    property string mediaTitle: "No media playing"
    property string mediaArtist: "Open a player"
    property string mediaStatus: "Stopped"
    property string mediaArt: ""
    property string mediaPlayer: ""
    property real mediaPosition: 0
    property real mediaDuration: 0
    readonly property real mediaProgress: mediaDuration > 0 ? Math.max(0, Math.min(1, mediaPosition / mediaDuration)) : 0
    property string batteryPercent: "--%"
    property string batteryStatus: "Unknown"
    property bool wifiEnabled: false
    property bool bluetoothEnabled: false
    property string wifiName: ""
    property string bluetoothName: ""
    property bool nightEnabled: false
    property bool caffeineEnabled: false
    property string connectivityMode: ""
    property bool settingsMode: false
    property var wifiNetworks: []
    property var bluetoothDevices: []
    property var selectedWifi: null
    property string wifiPassword: ""
    property string connectionMessage: ""
    property bool wifiScanning: false
    property bool bluetoothScanning: false
    property bool audioMode: false
    property bool iconCustomizerMode: false
    property bool extrasMode: false
    property bool taskbarSettingsMode: false
    property bool audioScanning: false
    property string audioError: ""
    property string defaultAudioSink: ""
    property var audioDevices: []
    readonly property var launcherIcons: [
        { name: "Home", glyph: "\ue88a", font: "Material Symbols Sharp Filled 36pt" },
        { name: "Linux", glyph: "\uf31a", font: "JetBrainsMono Nerd Font" },
        { name: "Alpine", glyph: "\uf300", font: "JetBrainsMono Nerd Font" },
        { name: "AOSC", glyph: "\uf301", font: "JetBrainsMono Nerd Font" },
        { name: "Arch Linux", glyph: "\uf303", font: "JetBrainsMono Nerd Font" },
        { name: "ArchLabs", glyph: "\uf31e", font: "JetBrainsMono Nerd Font" },
        { name: "Artix", glyph: "\uf31f", font: "JetBrainsMono Nerd Font" },
        { name: "Budgie", glyph: "\uf320", font: "JetBrainsMono Nerd Font" },
        { name: "CentOS", glyph: "\uf304", font: "JetBrainsMono Nerd Font" },
        { name: "CoreOS", glyph: "\uf305", font: "JetBrainsMono Nerd Font" },
        { name: "Debian", glyph: "\uf306", font: "JetBrainsMono Nerd Font" },
        { name: "Deepin", glyph: "\uf321", font: "JetBrainsMono Nerd Font" },
        { name: "Devuan", glyph: "\uf307", font: "JetBrainsMono Nerd Font" },
        { name: "Elementary", glyph: "\uf309", font: "JetBrainsMono Nerd Font" },
        { name: "EndeavourOS", glyph: "\uf322", font: "JetBrainsMono Nerd Font" },
        { name: "Fedora", glyph: "\uf30a", font: "JetBrainsMono Nerd Font" },
        { name: "Gentoo", glyph: "\uf30d", font: "JetBrainsMono Nerd Font" },
        { name: "GNU", glyph: "\uf325", font: "JetBrainsMono Nerd Font" },
        { name: "Kali", glyph: "\uf327", font: "JetBrainsMono Nerd Font" },
        { name: "Linux Mint", glyph: "\uf30e", font: "JetBrainsMono Nerd Font" },
        { name: "Mageia", glyph: "\uf310", font: "JetBrainsMono Nerd Font" },
        { name: "Mandriva", glyph: "\uf311", font: "JetBrainsMono Nerd Font" },
        { name: "Manjaro", glyph: "\uf312", font: "JetBrainsMono Nerd Font" },
        { name: "NixOS", glyph: "\uf313", font: "JetBrainsMono Nerd Font" },
        { name: "openSUSE", glyph: "\uf314", font: "JetBrainsMono Nerd Font" },
        { name: "Parabola", glyph: "\uf329", font: "JetBrainsMono Nerd Font" },
        { name: "Pop!_OS", glyph: "\uf32a", font: "JetBrainsMono Nerd Font" },
        { name: "Raspberry Pi", glyph: "\uf315", font: "JetBrainsMono Nerd Font" },
        { name: "Red Hat", glyph: "\uf316", font: "JetBrainsMono Nerd Font" },
        { name: "Rocky Linux", glyph: "\uf32b", font: "JetBrainsMono Nerd Font" },
        { name: "Sabayon", glyph: "\uf317", font: "JetBrainsMono Nerd Font" },
        { name: "Slackware", glyph: "\uf318", font: "JetBrainsMono Nerd Font" },
        { name: "Solus", glyph: "\uf32d", font: "JetBrainsMono Nerd Font" },
        { name: "Ubuntu", glyph: "\uf31b", font: "JetBrainsMono Nerd Font" },
        { name: "Void Linux", glyph: "\uf32e", font: "JetBrainsMono Nerd Font" },
        { name: "Zorin OS", glyph: "\uf32f", font: "JetBrainsMono Nerd Font" },
        { name: "FreeBSD", glyph: "\uf30c", font: "JetBrainsMono Nerd Font" },
        { name: "OpenBSD", glyph: "\uf328", font: "JetBrainsMono Nerd Font" },
        { name: "NetBSD", glyph: "\uf30c", font: "JetBrainsMono Nerd Font" },
        { name: "DragonFly BSD", glyph: "\uf30c", font: "JetBrainsMono Nerd Font" },
        { name: "GhostBSD", glyph: "\uf30c", font: "JetBrainsMono Nerd Font" },
        { name: "HardenedBSD", glyph: "\uf30c", font: "JetBrainsMono Nerd Font" },
        { name: "MidnightBSD", glyph: "\uf30c", font: "JetBrainsMono Nerd Font" },
        { name: "NomadBSD", glyph: "\uf30c", font: "JetBrainsMono Nerd Font" },
        { name: "BSD", glyph: "\uf30c", font: "JetBrainsMono Nerd Font" }
    ]
    property string wifiScanError: ""
    property string bluetoothScanError: ""
    readonly property var taskbarTextColors: ["#cdd6f4", "#bac2de", "#cba6f7", "#f5c2e7", "#f38ba8", "#fab387", "#f9e2af", "#a6e3a1", "#94e2d5", "#89dceb", "#74c7ec", "#89b4fa"]
    readonly property color panelColor: Config.colors.shadow || "#11111b"
    readonly property color surfaceColor: Config.colors.base || "#1e1e2e"
    readonly property color raisedColor: Config.colors.highlight || "#313244"
    readonly property color outlineColor: Config.colors.accentDark || "#45475a"
    readonly property color foregroundColor: Config.colors.textLight || "#cdd6f4"
    readonly property color secondaryColor: Qt.darker(foregroundColor, 1.12)
    readonly property color controlActiveColor: Config.colors.accent || "#cba6f7"
    readonly property color dangerColor: Config.colors.danger || "#f38ba8"
    readonly property color contentOutlineColor: Config.colors.outline || outlineColor
    readonly property color shellOutlineColor: Config.settings.ui.shellOutlineColor || "#ff0000"
    readonly property string homeDirectory: Quickshell.env("HOME") || "/home/akk"
    property bool pickerVisible: false
    property string pickerMode: ""
    property string pickerFolder: "file://" + homeDirectory + "/Pictures"
    property string selectedPickerPath: ""
    property string avatarPath: Config.settings.ui.avatarPath || ""
    property string wallpaperPath: Config.settings.ui.wallpaperPath || ""
    readonly property string defaultWallpaperPath: homeDirectory + "/Downloads/01.jpg"

    readonly property var currentWeather: Config.weatherData && Config.weatherData.current_condition ? Config.weatherData.current_condition[0] : null
    readonly property var weatherArea: Config.weatherData && Config.weatherData.nearest_area ? Config.weatherData.nearest_area[0] : null
    readonly property string weatherCity: weatherArea && weatherArea.areaName ? weatherArea.areaName[0].value : (Config.settings.openWeatherMap.city || "Weather")
    readonly property string weatherTemp: currentWeather ? `${currentWeather.temp_C}°C` : "--°C"
    readonly property string weatherFeels: currentWeather ? `${currentWeather.FeelsLikeC}°C` : "--°C"
    readonly property string weatherSummary: currentWeather && currentWeather.weatherDesc ? currentWeather.weatherDesc[0].value : "No weather data"
    readonly property string weatherIcon: {
        const summary = weatherSummary.toLowerCase();
        if (summary.includes("thunder")) return "\uf0e7";
        if (summary.includes("snow") || summary.includes("sleet")) return "\uf2dc";
        if (summary.includes("rain") || summary.includes("drizzle")) return "\uf043";
        if (summary.includes("cloud") || summary.includes("overcast")) return "\uf0c2";
        if (summary.includes("fog") || summary.includes("mist")) return "\uf0c2";
        return "\uf185";
    }

    function filePathFromUrl(url) {
        const text = String(url);
        if (text.startsWith("file://"))
            return decodeURIComponent(text.replace(/^file:\/\//, ""));
        return text;
    }

    function imageSource(path) {
        if (!path || path.length === 0)
            return "";
        return path.match(/\.(png|jpe?g|webp|bmp|gif)$/i) ? `file://${path}` : "";
    }

    function normalizedColorCode(value) {
        const code = String(value).trim();
        if (/^#[0-9a-fA-F]{6}$/.test(code))
            return code.toLowerCase();
        if (/^#[0-9a-fA-F]{3}$/.test(code))
            return ("#" + code[1] + code[1] + code[2] + code[2] + code[3] + code[3]).toLowerCase();
        return "";
    }

    function applyShellOutlineColor(value) {
        const code = normalizedColorCode(String(value));
        if (code !== "")
            Config.settings.ui.shellOutlineColor = code;
    }

    ColorDialog {
        id: shellOutlinePicker
        title: "Choose shell outline color"
        selectedColor: root.shellOutlineColor
        onAccepted: root.applyShellOutlineColor(selectedColor)
    }

    function colorLuminance(code) {
        const normalized = normalizedColorCode(code);
        if (normalized === "") return 0;
        function channel(offset) {
            const value = parseInt(normalized.slice(offset, offset + 2), 16) / 255;
            return value <= 0.03928 ? value / 12.92 : Math.pow((value + 0.055) / 1.055, 2.4);
        }
        return 0.2126 * channel(1) + 0.7152 * channel(3) + 0.0722 * channel(5);
    }

    function taskbarTextContrastIsSafe(code) {
        const foreground = colorLuminance(code);
        const background = colorLuminance("#1e1e2e");
        return (Math.max(foreground, background) + 0.05) / (Math.min(foreground, background) + 0.05) >= 3;
    }

    function applyAvatar(path) {
        const normalizedPath = filePathFromUrl(path).trim();
        if (!normalizedPath.match(/\.(png|jpe?g|webp|bmp|gif)$/i))
            return;
        Config.settings.ui.avatarPath = normalizedPath;
        avatarPath = normalizedPath;
    }

    function chooseAvatar() {
        openPicker("avatar");
    }

    function applyWallpaper(path) {
        Config.settings.ui.wallpaperPath = path;
        wallpaperPath = path;
        Quickshell.execDetached([homeDirectory + "/.config/desktop-shell/apply-wallpaper.sh", path]);
    }

    function applyDefaultWallpaper() {
        applyWallpaper(defaultWallpaperPath);
        closePicker();
    }

    function openPicker(mode) {
        pickerMode = mode;
        selectedPickerPath = "";
        if (mode === "avatar" && imageSource(avatarPath).length > 0) {
            pickerFolder = "file://" + avatarPath.replace(/\/[^/]+$/, "");
            selectedPickerPath = avatarPath;
        } else if (mode === "wallpaper" && wallpaperPath.length > 0) {
            pickerFolder = "file://" + wallpaperPath.replace(/\/[^/]+$/, "");
            selectedPickerPath = wallpaperPath;
        } else
            pickerFolder = "file://" + homeDirectory + "/Pictures";
        pickerVisible = true;
    }

    function closePicker() {
        pickerVisible = false;
    }

    function selectedPickerTitle() {
        return pickerMode === "avatar" ? "Choose profile photo" : "Choose wallpaper";
    }

    function selectedPickerAccept(path) {
        if (pickerMode === "avatar")
            root.applyAvatar(path);
        else if (pickerMode === "wallpaper")
            root.applyWallpaper(path);
        root.closePicker();
    }

    function refreshIdentity() {
        if (!identityQuery.running)
            identityQuery.running = true;
    }

    function refreshMedia() {
        if (!mediaQuery.running)
            mediaQuery.running = true;
    }

    function cleanMediaText(value) {
        return String(value || "")
            .replace(/<[^>]*>/g, " ")
            .replace(/&amp;/g, "&")
            .replace(/&lt;/g, "<")
            .replace(/&gt;/g, ">")
            .replace(/&quot;/g, "\"")
            .replace(/&#39;/g, "'")
            .replace(/\\n/g, " ")
            .replace(/\s+/g, " ")
            .trim();
    }

    function mediaAction(action) {
        if (mediaPlayer.length === 0 || mediaActionProcess.running)
            return;
        mediaActionProcess.command = ["playerctl", "--player=" + mediaPlayer, action];
        mediaActionProcess.running = true;
    }

    function mediaSeek(position) {
        if (mediaPlayer.length === 0 || mediaActionProcess.running || mediaDuration <= 0)
            return;
        mediaActionProcess.command = ["playerctl", "--player=" + mediaPlayer, "position", String(Math.max(0, Math.min(mediaDuration, position)))];
        mediaActionProcess.running = true;
    }

    function formatMediaTime(seconds) {
        const value = Math.max(0, Math.floor(Number(seconds) || 0));
        const minutes = Math.floor(value / 60);
        const remainder = value % 60;
        return minutes + ":" + (remainder < 10 ? "0" : "") + remainder;
    }

    function refreshBattery() {
        if (!batteryQuery.running)
            batteryQuery.running = true;
    }

    function refreshNetwork() {
        if (!wifiQuery.running)
            wifiQuery.running = true;
        if (!bluetoothQuery.running)
            bluetoothQuery.running = true;
    }

    function openConnectivity(mode) {
        audioMode = false;
        iconCustomizerMode = false;
        extrasMode = false;
        taskbarSettingsMode = false;
        settingsMode = false;
        connectivityMode = mode;
        selectedWifi = null;
        wifiPassword = "";
        connectionMessage = "";
        if (mode === "wifi" && wifiEnabled) {
            if (!wifiScan.running)
                wifiScan.running = true;
        } else if (mode === "bluetooth" && bluetoothEnabled && !bluetoothScan.running) {
            bluetoothScan.running = true;
        }
    }

    function closeConnectivity() {
        connectivityMode = "";
        settingsMode = false;
        selectedWifi = null;
        wifiPassword = "";
        connectionMessage = "";
    }

    function openSettingsPanel() {
        audioMode = false;
        iconCustomizerMode = false;
        extrasMode = false;
        taskbarSettingsMode = false;
        connectivityMode = "";
        settingsMode = true;
        connectionMessage = "";
    }

    function openAudioDevices() {
        iconCustomizerMode = false;
        connectivityMode = "";
        settingsMode = false;
        audioMode = true;
        audioError = "";
        if (!audioDeviceQuery.running)
            audioDeviceQuery.running = true;
    }

    function closeAudioDevices() {
        audioMode = false;
    }

    function openIconCustomizer() {
        connectivityMode = "";
        settingsMode = false;
        audioMode = false;
        iconCustomizerMode = true;
    }

    function openExtrasSettings() {
        connectivityMode = "";
        settingsMode = false;
        audioMode = false;
        iconCustomizerMode = false;
        extrasMode = true;
    }

    function openTaskbarSettings() {
        connectivityMode = "";
        settingsMode = false;
        audioMode = false;
        iconCustomizerMode = false;
        extrasMode = false;
        taskbarSettingsMode = true;
    }

    function closeTaskbarSettings() {
        taskbarSettingsMode = false;
        settingsMode = true;
    }

    function closeExtrasSettings() {
        extrasMode = false;
        taskbarSettingsMode = false;
        settingsMode = true;
    }

    function closeIconCustomizer() {
        iconCustomizerMode = false;
        extrasMode = false;
        settingsMode = true;
    }

    function selectLauncherIcon(option) {
        Config.settings.bar.launcherIconName = option.name;
        Config.settings.bar.launcherIconGlyph = option.glyph;
        Config.settings.bar.launcherIconFont = option.font;
    }

    function selectAudioDevice(name) {
        if (!name || audioDeviceSelect.running)
            return;
        audioDeviceSelect.command = ["pactl", "set-default-sink", name];
        audioDeviceSelect.running = true;
    }

    function cycleTheme(direction) {
        const names = ["catppuccin", "gruvbox-dark-hard"];
        const current = names.indexOf(Config.settings.currentTheme);
        const next = (Math.max(0, current) + direction + names.length) % names.length;
        Config.settings.currentTheme = names[next];
    }

    function requestWifiConnection(network) {
        if (network.active) {
            if (wifiConnect.running)
                return;
            wifiConnect.command = ["nmcli", "connection", "down", "id", wifiName || network.ssid];
            connectionMessage = "Disconnecting…";
            wifiConnect.running = true;
            return;
        }
        selectedWifi = network;
        wifiPassword = "";
        connectionMessage = "";
        if (!network.secured)
            connectSelectedWifi();
    }

    function connectSelectedWifi() {
        if (!selectedWifi || wifiConnect.running)
            return;
        const command = ["nmcli", "device", "wifi", "connect", selectedWifi.ssid];
        if (wifiPassword.length > 0)
            command.push("password", wifiPassword);
        wifiConnect.command = command;
        connectionMessage = "Connecting…";
        wifiConnect.running = true;
    }

    function connectBluetoothDevice(address) {
        if (!address.match(/^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$/) || bluetoothConnect.running)
            return;
        bluetoothConnect.command = ["sh", "-lc", "bluetoothctl pair '" + address + "' >/dev/null 2>&1 || true; bluetoothctl trust '" + address + "' >/dev/null 2>&1 || true; bluetoothctl connect '" + address + "'"];
        connectionMessage = "Connecting…";
        bluetoothConnect.running = true;
    }

    function disconnectBluetoothDevice(address) {
        if (!address.match(/^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$/) || bluetoothConnect.running)
            return;
        bluetoothConnect.command = ["bluetoothctl", "disconnect", address];
        connectionMessage = "Disconnecting…";
        bluetoothConnect.running = true;
    }

    function toggleWifi() {
        const enabling = !wifiEnabled;
        wifiEnabled = enabling;
        connectionMessage = enabling ? "Turning Wi-Fi on…" : "Wi-Fi is off";
        if (!enabling) {
            wifiNetworks = [];
            selectedWifi = null;
        }
        Quickshell.execDetached([
            "sh",
            "-lc",
            "state=$(nmcli -t -f WIFI general 2>/dev/null | head -n 1); if [ \"$state\" = enabled ]; then nmcli radio wifi off; else nmcli radio wifi on; fi"
        ]);
        networkRefreshDelay.restart();
        connectivityScanDelay.restart();
    }

    function toggleBluetooth() {
        const enabling = !bluetoothEnabled;
        bluetoothEnabled = enabling;
        connectionMessage = enabling ? "Turning Bluetooth on…" : "Bluetooth is off";
        if (!enabling)
            bluetoothDevices = [];
        Quickshell.execDetached([
            "sh",
            "-lc",
            "state=$(bluetoothctl show 2>/dev/null | awk -F': ' '/Powered/ {print $2; exit} /PowerState/ {print $2; exit}'); if [ \"$state\" = yes ] || [ \"$state\" = on ]; then bluetoothctl power off; else rfkill unblock bluetooth 2>/dev/null || true; bluetoothctl power on; fi"
        ]);
        networkRefreshDelay.restart();
        connectivityScanDelay.restart();
    }

    function toggleNightColor() {
        nightEnabled = !nightEnabled;
        Quickshell.execDetached(["kcmshell6", "kcm_nightcolor"]);
    }

    function toggleCaffeine() {
        caffeineEnabled = !caffeineEnabled;
        // TODO: Replace this state toggle with a persistent systemd-inhibit
        // helper if you want caffeine to actually hold sleep/idle inhibition.
    }

    function closeControlCenter() {
        pickerVisible = false;
        audioMode = false;
        iconCustomizerMode = false;
        Config.openControlCenter = false;
    }

    onVisibleChanged: {
        if (visible) {
            refreshIdentity();
            refreshMedia();
            refreshBattery();
            refreshNetwork();
            Config.fetchWeatherData();
        }
    }

    Timer {
        interval: root.visible ? 2000 : 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refreshMedia()
    }

    Timer {
        interval: 15000
        running: root.visible
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refreshBattery()
    }

    Timer {
        interval: 30000
        running: root.visible
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refreshIdentity()
    }

    Timer {
        interval: 60000
        running: root.visible
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            Config.fetchWeatherData();
        }
    }

    Timer {
        interval: 8000
        running: root.visible
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refreshNetwork()
    }

    Timer {
        id: networkRefreshDelay
        interval: 1000
        repeat: false
        onTriggered: root.refreshNetwork()
    }

    Timer {
        id: connectivityScanDelay
        interval: 1600
        repeat: false
        onTriggered: {
            root.refreshNetwork();
            if (root.connectivityMode === "wifi" && root.wifiEnabled && !wifiScan.running)
                wifiScan.running = true;
            else if (root.connectivityMode === "bluetooth" && root.bluetoothEnabled && !bluetoothScan.running)
                bluetoothScan.running = true;
        }
    }

    Timer {
        id: mediaRefreshDelay
        interval: 250
        repeat: false
        onTriggered: root.refreshMedia()
    }

    Process {
        id: identityQuery
        command: ["sh", "-lc", "printf '%s\\n%s\\n' \"${USER:-akk}\" \"$(hostname -s 2>/dev/null || hostname 2>/dev/null || echo fedora)\"; awk '{printf \"%.2fh\\n\", $1 / 3600}' /proc/uptime 2>/dev/null || printf '%s\\n' '--h'"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split(/\r?\n/);
                root.identityName = lines[0] || "akk";
                root.identityHost = lines[1] || "fedora";
                root.uptimeText = lines[2] || "up --";
            }
        }
    }

    Process {
        id: mediaQuery
        command: ["sh", "-lc", "chosen=''; paused=''; fallback=''; for p in $(playerctl -l 2>/dev/null); do state=$(playerctl --player=\"$p\" status 2>/dev/null || true); [ -z \"$fallback\" ] && fallback=\"$p\"; [ \"$state\" = 'Paused' ] && [ -z \"$paused\" ] && paused=\"$p\"; if [ \"$state\" = 'Playing' ]; then chosen=\"$p\"; break; fi; done; [ -z \"$chosen\" ] && chosen=\"${paused:-$fallback}\"; if [ -n \"$chosen\" ]; then printf '%s\\n' \"$chosen\"; playerctl --player=\"$chosen\" status 2>/dev/null || printf 'Stopped\\n'; playerctl --player=\"$chosen\" metadata --format '{{title}}|||{{artist}}|||{{mpris:artUrl}}|||{{mpris:length}}' 2>/dev/null || true; playerctl --player=\"$chosen\" position 2>/dev/null || printf '0\\n'; fi"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.split(/\r?\n/).map(line => line.trim());
                const metadata = (lines[2] || "").split("|||");
                root.mediaPlayer = lines[0] || "";
                root.mediaStatus = lines[1] || "Stopped";
                root.mediaTitle = root.cleanMediaText(metadata[0]) || "No media playing";
                root.mediaArtist = root.cleanMediaText(metadata[1]) || "Open a player";
                root.mediaArt = String(metadata[2] || "").trim();
                root.mediaDuration = Math.max(0, Number(metadata[3] || 0) / 1000000);
                root.mediaPosition = Math.max(0, Number(lines[3] || 0));
            }
        }
    }

    Process {
        id: mediaActionProcess
        command: []
        running: false
        onExited: {
            mediaRefreshDelay.restart();
        }
    }

    Process {
        id: batteryQuery
        command: ["sh", "-lc", "bat=$(ls /sys/class/power_supply 2>/dev/null | grep '^BAT' | head -n 1); if [ -n \"$bat\" ]; then printf '%s\\n%s\\n' \"$(cat /sys/class/power_supply/$bat/capacity 2>/dev/null)\" \"$(cat /sys/class/power_supply/$bat/status 2>/dev/null)\"; else printf '%s\\n%s\\n' '' 'Unknown'; fi"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split(/\r?\n/).filter(line => line.length > 0);
                const percent = lines[0] || "";
                root.batteryPercent = percent ? `${percent}%` : "--%";
                root.batteryStatus = lines[1] || "Unknown";
            }
        }
    }

    Process {
        id: wifiQuery
        command: ["sh", "-lc", "printf '%s\\n' \"$(nmcli -t -f WIFI general 2>/dev/null | head -n 1)\"; nmcli -t -f NAME,TYPE connection show --active 2>/dev/null | awk -F: '$2 == \"802-11-wireless\" {gsub(/\\\\:/, \":\", $1); print $1; exit}'"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split(/\r?\n/);
                root.wifiEnabled = lines[0] === "enabled";
                root.wifiName = lines[1] || "";
            }
        }
    }

    Process {
        id: bluetoothQuery
        command: ["sh", "-lc", "printf '%s\\n' \"$(bluetoothctl show 2>/dev/null | awk -F': ' '/Powered/ {print $2; exit} /PowerState/ {print $2; exit}')\"; bluetoothctl devices Connected 2>/dev/null | sed -n '1s/^Device [^ ]* //p'"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split(/\r?\n/);
                const state = lines[0] || "";
                root.bluetoothEnabled = state === "yes" || state === "on";
                root.bluetoothName = lines[1] || "";
            }
        }
    }

    Process {
        id: wifiScan
        command: ["sh", "-lc", "timeout 5s nmcli device wifi rescan >/dev/null 2>&1 || true; nmcli --terse --escape no --fields IN-USE,SSID,SIGNAL,SECURITY device wifi list --rescan no"]
        running: false
        onRunningChanged: {
            root.wifiScanning = running;
            if (running)
                root.wifiScanError = "";
        }

        stdout: StdioCollector {
            onStreamFinished: {
                const seen = {};
                const networks = [];
                text.trim().split(/\r?\n/).forEach(line => {
                    const fields = line.split(":");
                    const ssid = (fields[1] || "").trim();
                    if (!ssid || seen[ssid]) return;
                    seen[ssid] = true;
                    const security = (fields[3] || "").trim();
                    networks.push({
                        active: (fields[0] || "").trim() === "*",
                        ssid: ssid,
                        signal: Number(fields[2] || 0),
                        security: security,
                        secured: security.length > 0 && security !== "--"
                    });
                });
                networks.sort((a, b) => (b.active - a.active) || (b.signal - a.signal));
                root.wifiNetworks = networks;
            }
        }
        stderr: StdioCollector { onStreamFinished: if (text.trim()) root.wifiScanError = "Could not scan Wi-Fi" }
        onExited: exitCode => { if (exitCode !== 0) root.wifiScanError = "Could not scan Wi-Fi" }
    }

    Process {
        id: bluetoothScan
        command: ["sh", "-lc", "timeout 4s bluetoothctl scan on >/dev/null 2>&1 || true; bluetoothctl scan off >/dev/null 2>&1 || true; connected=$(bluetoothctl devices Connected 2>/dev/null | awk '{print $2}'); bluetoothctl devices 2>/dev/null | while read -r _ address name; do active=0; case \" $connected \" in *\" $address \"*) active=1;; esac; printf '%s|%s|%s\\n' \"$active\" \"$address\" \"$name\"; done"]
        running: false
        onRunningChanged: {
            root.bluetoothScanning = running;
            if (running)
                root.bluetoothScanError = "";
        }

        stdout: StdioCollector {
            onStreamFinished: {
                const devices = [];
                text.trim().split(/\r?\n/).forEach(line => {
                    const match = line.match(/^([01])\|([0-9A-Fa-f:]{17})\|(.+)$/);
                    if (match)
                        devices.push({ active: match[1] === "1", address: match[2], name: match[3] });
                });
                devices.sort((a, b) => b.active - a.active);
                root.bluetoothDevices = devices;
            }
        }
        stderr: StdioCollector { onStreamFinished: if (text.trim()) root.bluetoothScanError = "Could not scan Bluetooth" }
        onExited: exitCode => { if (exitCode !== 0) root.bluetoothScanError = "Could not scan Bluetooth" }
    }

    Process {
        id: wifiConnect
        command: []
        running: false
        stdout: StdioCollector { onStreamFinished: root.connectionMessage = text.trim() }
        stderr: StdioCollector { onStreamFinished: if (text.trim()) root.connectionMessage = text.trim() }
        onExited: exitCode => {
            if (exitCode === 0) {
                root.connectionMessage = wifiConnect.command.indexOf("down") >= 0 ? "Disconnected" : "Connected";
                root.selectedWifi = null;
                root.refreshNetwork();
                wifiScan.running = true;
            }
        }
    }

    Process {
        id: bluetoothConnect
        command: []
        running: false
        stdout: StdioCollector { onStreamFinished: root.connectionMessage = text.trim() }
        stderr: StdioCollector { onStreamFinished: if (text.trim()) root.connectionMessage = text.trim() }
        onExited: exitCode => {
            if (exitCode === 0) {
                root.connectionMessage = bluetoothConnect.command.indexOf("disconnect") >= 0 ? "Disconnected" : "Connected";
                root.refreshNetwork();
                bluetoothScan.running = true;
            }
        }
    }

    Process {
        id: audioDeviceQuery
        command: ["sh", "-lc", "printf '%s\\n' \"$(pactl get-default-sink 2>/dev/null)\"; pactl -f json list sinks 2>/dev/null"]
        running: false
        onRunningChanged: {
            root.audioScanning = running;
            if (running)
                root.audioError = "";
        }

        stdout: StdioCollector {
            onStreamFinished: {
                const separator = text.indexOf("\n");
                root.defaultAudioSink = separator >= 0 ? text.slice(0, separator).trim() : "";
                const payload = separator >= 0 ? text.slice(separator + 1).trim() : "";
                try {
                    const sinks = payload.length > 0 ? JSON.parse(payload) : [];
                    root.audioDevices = sinks.map(sink => ({
                        name: sink.name || "",
                        description: sink.description || sink.name || "Unknown output",
                        active: sink.name === root.defaultAudioSink,
                        state: sink.state || "UNKNOWN"
                    })).sort((a, b) => (b.active - a.active) || a.description.localeCompare(b.description));
                } catch (error) {
                    root.audioDevices = [];
                    root.audioError = "Could not read audio outputs";
                }
            }
        }
        onExited: exitCode => {
            if (exitCode !== 0)
                root.audioError = "Could not read audio outputs";
        }
    }

    Process {
        id: audioDeviceSelect
        command: []
        running: false
        onExited: exitCode => {
            root.audioError = exitCode === 0 ? "" : "Could not change audio output";
            if (!audioDeviceQuery.running)
                audioDeviceQuery.running = true;
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: !root.pickerVisible
        onClicked: root.closeControlCenter()
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.visible
        onActivated: {
            if (root.pickerVisible)
                root.closePicker();
            else if (root.taskbarSettingsMode)
                root.closeTaskbarSettings();
            else if (root.extrasMode)
                root.closeExtrasSettings();
            else if (root.iconCustomizerMode)
                root.closeIconCustomizer();
            else if (root.audioMode)
                root.closeAudioDevices();
            else if (root.settingsMode || root.connectivityMode !== "")
                root.closeConnectivity();
            else
                root.closeControlCenter();
        }
    }

    Rectangle {
        id: panel

        anchors.horizontalCenter: Config.settings.bar.centerWorkspaces ? undefined : parent.horizontalCenter
        anchors.left: Config.settings.bar.centerWorkspaces ? parent.left : undefined
        anchors.leftMargin: Config.settings.bar.centerWorkspaces
                          ? (Config.settings.bar.layoutMode === "full" ? 12
                             : Math.max(12, (root.width - root.width * Config.settings.bar.widthPercent / 100) / 2))
                          : 0
        anchors.top: parent.top
        anchors.topMargin: Config.settings.bar.offset + Config.settings.bar.height + 6
        width: Math.min(400, Math.max(320, root.width - 24))
        height: Math.min((root.settingsMode || root.iconCustomizerMode || root.extrasMode || root.taskbarSettingsMode)
                         ? 530 : (trayDockRepeater.count > 0 ? 340 : 296), root.height - anchors.topMargin - 12)
        radius: 12
        color: root.panelColor
        border.width: 1
        border.color: root.shellOutlineColor
        clip: true

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 7
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 104
                spacing: 8

                Rectangle {
                    id: avatarCard
                    Layout.preferredWidth: 104
                    Layout.fillHeight: true
                    radius: width / 2
                    color: avatarMouse.containsMouse ? root.outlineColor : root.raisedColor
                    border.width: 1
                    border.color: root.contentOutlineColor
                    clip: false

                    ClippingRectangle {
                        anchors.fill: parent
                        anchors.margins: 2
                        radius: Math.min(width, height) / 2
                        color: "transparent"

                        Image {
                            id: avatarImage
                            anchors.fill: parent
                            source: root.imageSource(root.avatarPath)
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: false
                            cache: true
                            smooth: true
                            mipmap: true
                            sourceSize.width: 208
                            sourceSize.height: 208
                            visible: status === Image.Ready
                        }

                        IconText {
                            anchors.centerIn: parent
                            text: "\uf2bd"
                            pixel: 36
                            color: "#cba6f7"
                            visible: avatarImage.status !== Image.Ready
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: Qt.rgba(0, 0, 0, 0.42)
                            opacity: avatarMouse.containsMouse ? 1 : 0

                            Behavior on opacity {
                                NumberAnimation { duration: 120 }
                            }

                            IconText {
                                anchors.centerIn: parent
                                text: "\uf030"
                                pixel: 22
                                color: "#cdd6f4"
                            }
                        }
                    }

                    MouseArea {
                        id: avatarMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.chooseAvatar()
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 8

                    Card {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 8

                            Column {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                spacing: 2

                                Body {
                                    width: parent.width
                                    text: root.identityName
                                    color: root.controlActiveColor
                                    font.pixelSize: 15
                                    font.bold: true
                                    elide: Text.ElideRight
                                }

                                Body {
                                    width: parent.width
                                    text: root.identityHost
                                    font.pixelSize: 10
                                    elide: Text.ElideRight
                                }
                            }

                            Caption {
                                Layout.preferredWidth: 112
                                Layout.alignment: Qt.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                text: root.uptimeText
                                font.pixelSize: 10
                            }
                        }
                    }

                    Card {
                        id: weatherCard
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        color: root.surfaceColor

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 8

                            IconText {
                                Layout.preferredWidth: 32
                                Layout.fillHeight: true
                                text: root.weatherIcon
                                pixel: 23
                                color: "#f9e2af"
                            }

                            Column {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                spacing: 1

                                Body {
                                    width: parent.width
                                    text: root.weatherCity
                                    font.pixelSize: 10
                                    elide: Text.ElideRight
                                }

                                Caption {
                                    width: parent.width
                                    text: Config.weatherLoading ? "Refreshing weather…" : (Config.weatherError || root.weatherSummary)
                                    color: Config.weatherError ? root.dangerColor : root.foregroundColor
                                    font.pixelSize: 8
                                    elide: Text.ElideRight
                                }
                            }

                            Body {
                                text: root.weatherTemp
                                font.pixelSize: 16
                            }

                            Caption {
                                text: root.weatherFeels
                                font.pixelSize: 8
                            }
                        }

                        MouseArea {
                            id: weatherMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Config.fetchWeatherData()
                        }
                    }
                }
            }

            Card {
                id: mediaCard
                Layout.fillWidth: true
                Layout.preferredHeight: 112
                radius: 12
                color: root.surfaceColor
                border.width: 1
                border.color: Qt.rgba(root.shellOutlineColor.r, root.shellOutlineColor.g, root.shellOutlineColor.b, 0.68)
                clip: true

                ClippingRectangle {
                    id: mediaThumbnail
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.margins: 8
                    width: height
                    radius: 10
                    color: "#181825"

                    Image {
                        id: mediaArtwork
                        anchors.fill: parent
                        source: root.mediaArt
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: false
                        cache: true
                        sourceSize.width: 256
                        sourceSize.height: 256
                        visible: status === Image.Ready
                    }

                    IconText {
                        anchors.centerIn: parent
                        text: "\uf001"
                        pixel: 24
                        color: "#6c7086"
                        visible: mediaArtwork.status !== Image.Ready
                    }
                }

                Column {
                    anchors.left: mediaThumbnail.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: 14
                    anchors.rightMargin: 12
                    anchors.topMargin: 14
                    spacing: 4

                    Body {
                        width: parent.width
                        text: root.mediaTitle
                        color: "#cdd6f4"
                        font.pixelSize: 13
                        font.bold: true
                        elide: Text.ElideRight
                    }

                    Body {
                        width: parent.width
                        text: root.mediaArtist
                        color: "#a6adc8"
                        font.pixelSize: 10
                        elide: Text.ElideRight
                    }

                    Row {
                        spacing: 5

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 6
                            height: 6
                            radius: 3
                            color: root.mediaStatus === "Playing" ? "#a6e3a1" : "#f9e2af"
                        }

                        Caption {
                            text: root.mediaPlayer ? root.mediaPlayer.toUpperCase() : "NO PLAYER"
                            font.pixelSize: 8
                            color: "#6c7086"
                        }
                    }
                }

                Row {
                    anchors.right: parent.right
                    anchors.bottom: timelineRow.top
                    anchors.rightMargin: 10
                    anchors.bottomMargin: 8
                    spacing: 8

                    TinyAction { icon: AudioSystem.muted ? "\ue04f" : "\ue050"; tooltipText: AudioSystem.muted ? "Unmute" : "Mute · " + Math.round(AudioSystem.volume * 100) + "%"; onClicked: AudioSystem.muted = !AudioSystem.muted }
                    TinyAction { icon: "\ue32e"; tooltipText: "Select audio output"; onClicked: root.openAudioDevices() }
                    TinyAction { enabled: root.mediaTitle !== "No media playing"; icon: "\ue045"; tooltipText: "Previous"; onClicked: root.mediaAction("previous") }
                    TinyAction { enabled: root.mediaTitle !== "No media playing"; primary: true; icon: root.mediaStatus === "Playing" ? "\ue034" : "\ue037"; tooltipText: root.mediaStatus === "Playing" ? "Pause" : "Play"; onClicked: root.mediaAction("play-pause") }
                    TinyAction { enabled: root.mediaTitle !== "No media playing"; icon: "\ue044"; tooltipText: "Next"; onClicked: root.mediaAction("next") }
                }

                RowLayout {
                    id: timelineRow
                    anchors.left: mediaThumbnail.right
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    anchors.bottomMargin: 8
                    height: 14
                    spacing: 6

                    Caption {
                        text: root.formatMediaTime(root.mediaPosition)
                        font.pixelSize: 8
                        color: "#6c7086"
                    }

                    Rectangle {
                        id: timelineTrack
                        Layout.fillWidth: true
                        Layout.preferredHeight: 3
                        radius: 1.5
                        color: root.outlineColor

                        Rectangle {
                            width: parent.width * root.mediaProgress
                            height: parent.height
                            radius: parent.radius
                            color: "#cba6f7"
                        }

                        Rectangle {
                            x: Math.max(0, Math.min(parent.width - width, parent.width * root.mediaProgress - width / 2))
                            anchors.verticalCenter: parent.verticalCenter
                            width: timelineMouse.containsMouse ? 10 : 8
                            height: width
                            radius: width / 2
                            color: "#f5e0dc"

                            Behavior on width { NumberAnimation { duration: 100 } }
                        }

                        MouseArea {
                            id: timelineMouse
                            anchors.fill: parent
                            enabled: root.mediaDuration > 0
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: mouse => root.mediaSeek((mouse.x / width) * root.mediaDuration)
                        }
                    }

                    Caption {
                        text: root.formatMediaTime(root.mediaDuration)
                        font.pixelSize: 8
                        color: "#6c7086"
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 39
                spacing: 8

                Item { Layout.fillWidth: true }
                ToggleTile { Layout.preferredWidth: 39; Layout.preferredHeight: 39; active: root.wifiEnabled; activeColor: root.controlActiveColor; icon: "\ue1ba"; tooltipText: root.wifiName || "Wi-Fi"; onClicked: root.openConnectivity("wifi") }
                ToggleTile { Layout.preferredWidth: 39; Layout.preferredHeight: 39; active: root.bluetoothEnabled; activeColor: root.controlActiveColor; icon: "\ue1a7"; tooltipText: root.bluetoothName || "Bluetooth"; onClicked: root.openConnectivity("bluetooth") }
                ToggleTile { Layout.preferredWidth: 39; Layout.preferredHeight: 39; active: false; activeColor: root.raisedColor; icon: "\ue8b8"; tooltipText: "Settings"; onClicked: root.openSettingsPanel() }
                ToggleTile { Layout.preferredWidth: 39; Layout.preferredHeight: 39; active: root.caffeineEnabled; activeColor: root.controlActiveColor; icon: "\uefef"; tooltipText: "Caffeine"; onClicked: root.toggleCaffeine() }
                ToggleTile { Layout.preferredWidth: 39; Layout.preferredHeight: 39; active: false; activeColor: root.raisedColor; icon: "\ue1bc"; tooltipText: "Wallpaper"; onClicked: root.openPicker("wallpaper") }
                ToggleTile { Layout.preferredWidth: 39; Layout.preferredHeight: 39; active: false; activeColor: root.raisedColor; icon: "\ue897"; tooltipText: "Lock"; onClicked: Quickshell.execDetached(["loginctl", "lock-session"]) }
                ToggleTile { Layout.preferredWidth: 39; Layout.preferredHeight: 39; active: false; activeColor: root.raisedColor; icon: "\uf8c7"; tooltipText: "Power"; onClicked: Quickshell.execDetached(["sh", "-lc", "kdialog --yesno 'Power off this computer?' --title 'Power' && systemctl poweroff"]) }
                Item { Layout.fillWidth: true }
            }

            Rectangle {
                id: trayDock
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: Math.min(panel.width - 20, trayDockRow.implicitWidth + 16)
                Layout.preferredHeight: trayDockRepeater.count > 0 ? 34 : 0
                visible: trayDockRepeater.count > 0
                radius: height / 2
                color: root.surfaceColor
                border.width: 1
                border.color: Qt.rgba(root.shellOutlineColor.r, root.shellOutlineColor.g, root.shellOutlineColor.b, 0.62)
                clip: true

                RowLayout {
                    id: trayDockRow
                    anchors.centerIn: parent
                    spacing: 5

                    Repeater {
                        id: trayDockRepeater
                        model: SystemTray.items

                        Item {
                            id: trayDockItem
                            required property SystemTrayItem modelData
                            Layout.preferredWidth: 25
                            Layout.preferredHeight: 25

                            QsMenuAnchor {
                                id: trayDockMenu
                                menu: trayDockItem.modelData.menu
                                anchor {
                                    item: trayDockItem
                                    edges: Edges.Bottom
                                    gravity: Edges.Bottom
                                    adjustment: PopupAdjustment.SlideX | PopupAdjustment.FlipY
                                }
                            }

                            Rectangle {
                                anchors.fill: parent
                                radius: 8
                                color: trayDockMouse.containsMouse || trayDockMenu.visible ? root.raisedColor : "transparent"
                            }

                            IconImage {
                                anchors.centerIn: parent
                                source: trayDockItem.modelData.icon
                                width: Config.settings.bar.trayIconSize
                                height: width
                                opacity: trayDockMouse.containsMouse || trayDockMenu.visible ? 1 : 0.82
                            }

                            MouseArea {
                                id: trayDockMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                cursorShape: Qt.PointingHandCursor
                                onClicked: event => {
                                    if (event.button === Qt.RightButton && trayDockItem.modelData.hasMenu)
                                        trayDockMenu.open();
                                    else
                                        trayDockItem.modelData.activate();
                                    event.accepted = true;
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            z: 20
            visible: root.connectivityMode !== "" || root.settingsMode
            radius: panel.radius
            color: root.panelColor

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 34
                    spacing: 8

                    ToggleTile {
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 34
                        active: false
                        activeColor: root.raisedColor
                        icon: "\ue5c4"
                        tooltipText: "Back"
                        onClicked: root.closeConnectivity()
                    }

                    Body {
                        Layout.fillWidth: true
                        text: root.settingsMode ? "Shell settings" : (root.connectivityMode === "wifi" ? "Wi-Fi networks" : "Bluetooth devices")
                        color: root.controlActiveColor
                        font.pixelSize: 15
                        font.bold: true
                    }

                    ToggleTile {
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 34
                        active: false
                        activeColor: root.raisedColor
                        icon: "\ue5d5"
                        tooltipText: "Refresh"
                        visible: !root.settingsMode
                        enabled: root.connectivityMode === "wifi" ? root.wifiEnabled : root.bluetoothEnabled
                        onClicked: {
                            root.connectionMessage = "";
                            if (root.connectivityMode === "wifi" && !wifiScan.running)
                                wifiScan.running = true;
                            else if (root.connectivityMode === "bluetooth" && !bluetoothScan.running)
                                bluetoothScan.running = true;
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 46
                    visible: !root.settingsMode
                    radius: 10
                    color: root.surfaceColor
                    border.width: 1
                    border.color: (root.connectivityMode === "wifi" ? root.wifiEnabled : root.bluetoothEnabled)
                                  ? root.controlActiveColor : root.contentOutlineColor

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 10
                        spacing: 10

                        Column {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 2

                            Body {
                                text: root.connectivityMode === "wifi" ? "Wi-Fi" : "Bluetooth"
                                font.pixelSize: 11
                                font.bold: true
                            }

                            Caption {
                                text: (root.connectivityMode === "wifi" ? root.wifiEnabled : root.bluetoothEnabled)
                                      ? "On · available connections are shown below" : "Off · turn on to discover connections"
                                font.pixelSize: 9
                            }
                        }

                        RadioSwitch {
                            checked: root.connectivityMode === "wifi" ? root.wifiEnabled : root.bluetoothEnabled
                            onToggled: {
                                if (root.connectivityMode === "wifi") root.toggleWifi();
                                else root.toggleBluetooth();
                            }
                        }
                    }
                }

                Caption {
                    Layout.fillWidth: true
                    visible: !root.settingsMode && root.connectionMessage.length > 0
                    text: root.connectionMessage
                    color: root.connectionMessage === "Connected" ? "#a6e3a1" : "#f9e2af"
                    elide: Text.ElideRight
                }

                Caption {
                    Layout.fillWidth: true
                    Layout.preferredHeight: visible ? 22 : 0
                    visible: !root.settingsMode && !(root.connectivityMode === "wifi" ? root.wifiEnabled : root.bluetoothEnabled)
                             || (!root.settingsMode && ((root.connectivityMode === "wifi" ? root.wifiScanning : root.bluetoothScanning)
                             || (root.connectivityMode === "wifi" ? root.wifiScanError : root.bluetoothScanError).length > 0
                             || (root.connectivityMode === "wifi" ? root.wifiNetworks.length : root.bluetoothDevices.length) === 0))
                    text: {
                        const enabled = root.connectivityMode === "wifi" ? root.wifiEnabled : root.bluetoothEnabled;
                        if (!enabled) return root.connectivityMode === "wifi" ? "Wi-Fi is turned off" : "Bluetooth is turned off";
                        const scanning = root.connectivityMode === "wifi" ? root.wifiScanning : root.bluetoothScanning;
                        const error = root.connectivityMode === "wifi" ? root.wifiScanError : root.bluetoothScanError;
                        if (scanning) return root.connectivityMode === "wifi" ? "Scanning for networks…" : "Scanning for devices…";
                        if (error.length > 0) return error + " · use refresh to retry";
                        return root.connectivityMode === "wifi" ? "No Wi-Fi networks found" : "No Bluetooth devices found";
                    }
                    color: (root.connectivityMode === "wifi" ? root.wifiScanError : root.bluetoothScanError).length > 0 ? root.dangerColor : root.foregroundColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 6
                    model: root.connectivityMode === "wifi" ? (root.wifiEnabled ? root.wifiNetworks : [])
                                                              : (root.bluetoothEnabled ? root.bluetoothDevices : [])
                    visible: !root.settingsMode

                    delegate: Rectangle {
                        required property var modelData
                        width: ListView.view.width
                        height: 48
                        radius: 10
                        color: connectionMouse.containsMouse ? root.outlineColor : root.surfaceColor
                        border.width: 1
                        border.color: root.contentOutlineColor

                        IconText {
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                            iconFamily: "Material Symbols Sharp Filled 36pt"
                            text: root.connectivityMode === "wifi" ? "\ue1ba" : "\ue1a7"
                            pixel: 18
                            color: modelData.active ? root.controlActiveColor : root.foregroundColor
                        }

                        Column {
                            anchors.left: parent.left
                            anchors.leftMargin: 44
                            anchors.right: parent.right
                            anchors.rightMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2

                            Body {
                                width: parent.width
                                text: root.connectivityMode === "wifi" ? modelData.ssid : modelData.name
                                color: "#cdd6f4"
                                font.pixelSize: 11
                                elide: Text.ElideRight
                            }

                            Caption {
                                width: parent.width
                                text: root.connectivityMode === "wifi" ? (modelData.active ? "Connected · click to disconnect" : modelData.signal + "%  " + modelData.security) : (modelData.active ? "Connected · click to disconnect" : modelData.address)
                                color: modelData.active ? root.controlActiveColor : root.secondaryColor
                                elide: Text.ElideRight
                            }
                        }

                        MouseArea {
                            id: connectionMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (root.connectivityMode === "wifi")
                                    root.requestWifiConnection(modelData);
                                else if (modelData.active)
                                    root.disconnectBluetoothDevice(modelData.address);
                                else
                                    root.connectBluetoothDevice(modelData.address);
                            }
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: root.settingsMode
                    spacing: 8

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        radius: 10
                        color: root.surfaceColor
                        border.width: 1
                        border.color: root.contentOutlineColor

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 8

                            Body { Layout.fillWidth: true; text: "Theme"; color: "#cdd6f4" }
                            ToggleTile { Layout.preferredWidth: 30; Layout.preferredHeight: 30; active: false; activeColor: root.raisedColor; icon: "\ue5cb"; tooltipText: "Previous theme"; onClicked: root.cycleTheme(-1) }
                            Caption { Layout.preferredWidth: 112; text: Config.settings.currentTheme; color: root.controlActiveColor; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
                            ToggleTile { Layout.preferredWidth: 30; Layout.preferredHeight: 30; active: false; activeColor: root.raisedColor; icon: "\ue5cc"; tooltipText: "Next theme"; onClicked: root.cycleTheme(1) }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        radius: 10
                        color: root.surfaceColor
                        border.width: 1
                        border.color: root.contentOutlineColor

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 8
                            spacing: 8

                            Body { Layout.fillWidth: true; text: "Taskbar"; font.pixelSize: 10 }
                            Caption {
                                text: Config.settings.bar.layoutMode === "full" ? "Full width" : "Compact"
                                color: root.controlActiveColor
                            }
                            PickerButton { text: "Open"; implicitWidth: 48; onClicked: root.openTaskbarSettings() }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        radius: 10
                        color: root.surfaceColor
                        border.width: 1
                        border.color: root.contentOutlineColor

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 8
                            spacing: 8

                            Body { Layout.fillWidth: true; text: "Outline color"; font.pixelSize: 10 }

                            Rectangle {
                                Layout.preferredWidth: 20
                                Layout.preferredHeight: 20
                                radius: 6
                                color: root.shellOutlineColor
                                border.width: 1
                                border.color: root.foregroundColor
                            }

                            Caption {
                                Layout.preferredWidth: 58
                                text: Config.settings.ui.shellOutlineColor
                                font.family: "monospace"
                                horizontalAlignment: Text.AlignHCenter
                            }

                            PickerButton {
                                text: "Choose"
                                implicitWidth: 58
                                onClicked: shellOutlinePicker.open()
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        radius: 10
                        color: root.surfaceColor
                        border.width: 1
                        border.color: root.contentOutlineColor

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 8
                            spacing: 8

                            Body { Layout.fillWidth: true; text: "Launcher icon"; font.pixelSize: 10 }

                            Text {
                                Layout.preferredWidth: 26
                                Layout.fillHeight: true
                                text: Config.settings.bar.launcherIconGlyph
                                color: root.foregroundColor
                                font.family: Config.settings.bar.launcherIconFont
                                font.pixelSize: 20
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            Caption {
                                Layout.preferredWidth: 82
                                text: Config.settings.bar.launcherIconName
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideRight
                            }

                            PickerButton {
                                text: "Icons"
                                implicitWidth: 52
                                onClicked: root.openIconCustomizer()
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        radius: 10
                        color: root.surfaceColor
                        border.width: 1
                        border.color: root.contentOutlineColor

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 8
                            spacing: 8

                            Body { Layout.fillWidth: true; text: "Additional options"; font.pixelSize: 10 }
                            Caption { text: "Bar · OSD · services"; font.pixelSize: 8 }
                            PickerButton { text: "Open"; implicitWidth: 48; onClicked: root.openExtrasSettings() }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 100
                        radius: 10
                        color: root.surfaceColor
                        border.width: 1
                        border.color: root.contentOutlineColor

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 9
                            spacing: 7

                            RowLayout {
                                Layout.fillWidth: true
                                Body { Layout.fillWidth: true; text: "Text color"; color: "#cdd6f4"; font.pixelSize: 10 }
                                Rectangle { Layout.preferredWidth: 18; Layout.preferredHeight: 18; radius: 9; color: Config.settings.bar.textColor; border.width: 1; border.color: root.contentOutlineColor }
                                Caption { text: Config.settings.bar.textColor; color: "#a6adc8" }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 7

                                Repeater {
                                    model: root.taskbarTextColors

                                    Rectangle {
                                        required property string modelData
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 20
                                        radius: 6
                                        color: modelData
                                        border.width: 1
                                        border.color: root.contentOutlineColor
                                        scale: swatchMouse.containsMouse ? 1.12 : 1

                                        Behavior on scale { NumberAnimation { duration: 100 } }

                                        MouseArea {
                                            id: swatchMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                Config.settings.bar.textColor = modelData;
                                                taskbarTextColorInput.text = modelData;
                                            }
                                        }
                                    }
                                }
                            }


                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 7

                                Caption {
                                    text: "HEX"
                                    color: "#a6adc8"
                                }

                                TextField {
                                    id: taskbarTextColorInput
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 26
                                    text: Config.settings.bar.textColor
                                    color: "#cdd6f4"
                                    selectionColor: "#585b70"
                                    selectedTextColor: "#ffffff"
                                    placeholderText: "#cdd6f4"
                                    placeholderTextColor: "#6c7086"
                                    font.family: "monospace"
                                    font.pixelSize: 11

                                    property bool codeValid: root.normalizedColorCode(text) !== ""
                                    property bool contrastSafe: codeValid && root.taskbarTextContrastIsSafe(text)

                                    function applyCode() {
                                        const normalized = root.normalizedColorCode(text);
                                        if (normalized !== "" && contrastSafe) {
                                            Config.settings.bar.textColor = normalized;
                                            text = normalized;
                                        }
                                    }

                                    onAccepted: applyCode()
                                    onEditingFinished: {
                                        if (codeValid && contrastSafe)
                                            applyCode();
                                        else
                                            text = Config.settings.bar.textColor;
                                    }

                                    background: Rectangle {
                                        radius: 7
                                        color: "#181825"
                                        border.width: 1
                                        border.color: taskbarTextColorInput.codeValid && taskbarTextColorInput.contrastSafe ? root.contentOutlineColor : root.dangerColor
                                    }

                                    ToolTip.visible: hovered
                                    ToolTip.text: !codeValid ? "Use #RGB or #RRGGBB" : (contrastSafe ? "Enter a color code" : "Color is too dark for the taskbar")
                                    ToolTip.delay: 400
                                }

                                ToggleTile {
                                    Layout.preferredWidth: 26
                                    Layout.preferredHeight: 26
                                    active: false
                                    activeColor: root.raisedColor
                                    icon: "\ue5ca"
                                    tooltipText: "Apply color code"
                                    onClicked: taskbarTextColorInput.applyCode()
                                }
                            }
                        }
                    }
                    SettingSlider { label: "Tray icons"; from: 10; to: 24; stepSize: 1; value: Config.settings.bar.trayIconSize; suffix: "px"; onChanged: value => Config.settings.bar.trayIconSize = Math.round(value) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 76
                    visible: root.connectivityMode === "wifi" && root.selectedWifi && root.selectedWifi.secured
                    radius: 10
                    color: root.surfaceColor
                    border.width: 1
                    border.color: root.contentOutlineColor

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 8

                        TextField {
                            Layout.fillWidth: true
                            placeholderText: "Password for " + (root.selectedWifi ? root.selectedWifi.ssid : "network")
                            echoMode: TextInput.Password
                            text: root.wifiPassword
                            onTextChanged: root.wifiPassword = text
                            color: "#cdd6f4"
                            placeholderTextColor: "#6c7086"
                            background: Rectangle {
                                radius: 8
                                color: "#181825"
                                border.width: 1
                                border.color: root.contentOutlineColor
                            }
                            Keys.onReturnPressed: root.connectSelectedWifi()
                        }

                        PickerButton {
                            text: "Connect"
                            enabled: root.wifiPassword.length > 0
                            onClicked: root.connectSelectedWifi()
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        x: panel.x
        y: panel.y
        width: panel.width
        height: panel.height
        visible: root.taskbarSettingsMode
        z: 29
        radius: panel.radius
        color: root.panelColor
        border.width: 1
        border.color: root.shellOutlineColor
        clip: true

        MouseArea { anchors.fill: parent; onClicked: {} }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 7

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 36

                ToggleTile {
                    Layout.preferredWidth: 34
                    Layout.preferredHeight: 34
                    active: false
                    activeColor: root.raisedColor
                    icon: "\ue5c4"
                    tooltipText: "Back to settings"
                    onClicked: root.closeTaskbarSettings()
                }

                Column {
                    Layout.fillWidth: true
                    spacing: 1
                    Body { text: "Taskbar settings"; color: root.controlActiveColor; font.pixelSize: 15; font.bold: true }
                    Caption { text: "Layout, position and edge treatment"; font.pixelSize: 8 }
                }
            }

            Caption { Layout.fillWidth: true; text: "LAYOUT"; color: root.controlActiveColor; font.bold: true }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                spacing: 8

                ChoiceButton {
                    Layout.fillWidth: true
                    label: "Compact"
                    detail: "Current"
                    selected: Config.settings.bar.layoutMode === "compact"
                    onClicked: Config.settings.bar.layoutMode = "compact"
                }
                ChoiceButton {
                    Layout.fillWidth: true
                    label: "Full width"
                    detail: "Display"
                    selected: Config.settings.bar.layoutMode === "full"
                    onClicked: Config.settings.bar.layoutMode = "full"
                }
            }

            OptionToggle {
                label: "Center workspaces"
                detail: "Move Roman numerals to center and Home to the left"
                checked: Config.settings.bar.centerWorkspaces
                onToggled: Config.settings.bar.centerWorkspaces = !Config.settings.bar.centerWorkspaces
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 52
                radius: 10
                color: root.surfaceColor
                border.width: 1
                border.color: root.contentOutlineColor

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 10 + Config.settings.bar.offset * 0.18
                    width: Config.settings.bar.layoutMode === "full" ? parent.width - 20
                          : (parent.width - 20) * Config.settings.bar.widthPercent / 100
                    height: Math.max(8, Config.settings.bar.height * 0.42)
                    radius: Config.settings.bar.edgeStyle === "rounded" ? Config.settings.bar.radius * 0.42 : 0
                    color: Qt.rgba(root.surfaceColor.r, root.surfaceColor.g, root.surfaceColor.b, Config.settings.bar.opacity)
                    border.width: 1
                    border.color: root.shellOutlineColor

                    Text {
                        anchors.centerIn: parent
                        text: Config.settings.bar.edgeStyle === "goth-cut" ? "◆  GOTH CUT  ◆" : "I   II       ◉       󰕾   12:30"
                        color: root.foregroundColor
                        font.family: fontGgSans.name
                        font.pixelSize: 7
                    }
                }
            }

            SettingSlider {
                visible: Config.settings.bar.layoutMode === "compact"
                label: "Width"
                from: 30; to: 95; stepSize: 5
                value: Config.settings.bar.widthPercent
                suffix: "%"
                onChanged: value => Config.settings.bar.widthPercent = Math.round(value)
            }
            SettingSlider { label: "Offset"; from: 0; to: 32; stepSize: 1; value: Config.settings.bar.offset; suffix: "px"; onChanged: value => Config.settings.bar.offset = Math.round(value) }
            SettingSlider { label: "Height"; from: 26; to: 48; stepSize: 1; value: Config.settings.bar.height; suffix: "px"; onChanged: value => Config.settings.bar.height = Math.round(value) }
            SettingSlider { label: "Opacity"; from: 0.2; to: 1; stepSize: 0.05; value: Config.settings.bar.opacity; multiplier: 100; suffix: "%"; onChanged: value => Config.settings.bar.opacity = value }

            Caption { Layout.fillWidth: true; text: "EDGES"; color: root.controlActiveColor; font.bold: true }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                spacing: 7

                ChoiceButton { Layout.fillWidth: true; label: "Rounded"; selected: Config.settings.bar.edgeStyle === "rounded"; onClicked: Config.settings.bar.edgeStyle = "rounded" }
                ChoiceButton { Layout.fillWidth: true; label: "Square"; selected: Config.settings.bar.edgeStyle === "square"; onClicked: Config.settings.bar.edgeStyle = "square" }
                ChoiceButton { Layout.fillWidth: true; label: "Goth Cut"; selected: Config.settings.bar.edgeStyle === "goth-cut"; onClicked: Config.settings.bar.edgeStyle = "goth-cut" }
            }

            SettingSlider {
                visible: Config.settings.bar.edgeStyle === "rounded"
                label: "Curves"
                from: 0; to: 18; stepSize: 1
                value: Config.settings.bar.radius
                suffix: "px"
                onChanged: value => Config.settings.bar.radius = Math.round(value)
            }

            Item { Layout.fillHeight: true }
        }
    }

    Rectangle {
        x: panel.x
        y: panel.y
        width: panel.width
        height: panel.height
        visible: root.extrasMode
        z: 28
        radius: panel.radius
        color: root.panelColor
        border.width: 1
        border.color: root.shellOutlineColor
        clip: true

        MouseArea { anchors.fill: parent; onClicked: {} }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 36

                ToggleTile {
                    Layout.preferredWidth: 34
                    Layout.preferredHeight: 34
                    active: false
                    activeColor: root.raisedColor
                    icon: "\ue5c4"
                    tooltipText: "Back to settings"
                    onClicked: root.closeExtrasSettings()
                }

                Column {
                    Layout.fillWidth: true
                    spacing: 1
                    Body { text: "Additional options"; color: root.controlActiveColor; font.pixelSize: 15; font.bold: true }
                    Caption { text: "Optional features stay out of the default bar"; font.pixelSize: 8 }
                }
            }

            Caption { Layout.fillWidth: true; text: "TASKBAR"; color: root.controlActiveColor; font.bold: true }
            OptionToggle { label: "Active window title"; detail: "Show the focused window beside workspaces"; checked: Config.settings.bar.showActiveWindow; onToggled: Config.settings.bar.showActiveWindow = !Config.settings.bar.showActiveWindow }
            OptionToggle { label: "Battery percentage"; detail: "Show battery status before the clock"; checked: Config.settings.bar.showBatteryIndicator; onToggled: Config.settings.bar.showBatteryIndicator = !Config.settings.bar.showBatteryIndicator }
            OptionToggle { label: "Scroll for volume"; detail: "Adjust volume while scrolling over the tray"; checked: Config.settings.bar.scrollVolume; onToggled: Config.settings.bar.scrollVolume = !Config.settings.bar.scrollVolume }
            OptionToggle { label: "Smart transparency"; detail: "Use a lighter translucent bar surface"; checked: Config.settings.bar.smartTransparency; onToggled: Config.settings.bar.smartTransparency = !Config.settings.bar.smartTransparency }
            OptionToggle { label: "Reduce motion"; detail: "Disable hover and state animations"; checked: Config.settings.bar.reduceMotion; onToggled: Config.settings.bar.reduceMotion = !Config.settings.bar.reduceMotion }

            Caption { Layout.fillWidth: true; text: "FEEDBACK & SERVICES"; color: root.controlActiveColor; font.bold: true }
            OptionToggle { label: "Volume OSD"; detail: "Show feedback when output volume changes"; checked: Config.settings.extras.volumeOsd; onToggled: Config.settings.extras.volumeOsd = !Config.settings.extras.volumeOsd }
            OptionToggle { label: "Brightness OSD"; detail: "Requires brightnessctl (not installed)"; available: false; checked: Config.settings.extras.brightnessOsd; onToggled: Config.settings.extras.brightnessOsd = !Config.settings.extras.brightnessOsd }
            OptionToggle { label: "Notification center"; detail: "Enable shell-managed notification history"; checked: Config.settings.extras.notifications; onToggled: Config.settings.extras.notifications = !Config.settings.extras.notifications }
            OptionToggle { label: "Clipboard history"; detail: "Requires cliphist (not installed)"; available: false; checked: Config.settings.extras.clipboardHistory; onToggled: Config.settings.extras.clipboardHistory = !Config.settings.extras.clipboardHistory }
            OptionToggle { label: "Wallpaper colors"; detail: "Requires matugen (not installed)"; available: false; checked: Config.settings.extras.wallpaperColors; onToggled: Config.settings.extras.wallpaperColors = !Config.settings.extras.wallpaperColors }

            Item { Layout.fillHeight: true }
        }
    }

    Rectangle {
        x: panel.x
        y: panel.y
        width: panel.width
        height: panel.height
        visible: root.iconCustomizerMode
        z: 27
        radius: panel.radius
        color: root.panelColor
        border.width: 1
        border.color: root.shellOutlineColor
        clip: true

        MouseArea { anchors.fill: parent; onClicked: {} }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 34
                spacing: 8

                ToggleTile {
                    Layout.preferredWidth: 34
                    Layout.preferredHeight: 34
                    active: false
                    activeColor: root.raisedColor
                    icon: "\ue5c4"
                    tooltipText: "Back to settings"
                    onClicked: root.closeIconCustomizer()
                }

                Column {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 1

                    Body {
                        width: parent.width
                        text: "Launcher icon"
                        color: root.controlActiveColor
                        font.pixelSize: 15
                        font.bold: true
                    }

                    Caption {
                        width: parent.width
                        text: "Linux, BSD and Home icons"
                        font.pixelSize: 9
                    }
                }

                Text {
                    Layout.preferredWidth: 34
                    Layout.preferredHeight: 34
                    text: Config.settings.bar.launcherIconGlyph
                    color: root.foregroundColor
                    font.family: Config.settings.bar.launcherIconFont
                    font.pixelSize: 23
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            GridView {
                id: launcherIconGrid
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                cellWidth: width / 4
                cellHeight: 68
                model: root.launcherIcons

                delegate: Item {
                    required property var modelData
                    width: launcherIconGrid.cellWidth
                    height: launcherIconGrid.cellHeight

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 3
                        radius: 10
                        color: iconChoiceMouse.containsMouse ? root.raisedColor : root.surfaceColor
                        border.width: 1
                        border.color: Config.settings.bar.launcherIconName === modelData.name
                                      ? root.controlActiveColor : root.contentOutlineColor

                        Column {
                            anchors.centerIn: parent
                            width: parent.width - 8
                            spacing: 4

                            Text {
                                width: parent.width
                                height: 28
                                text: modelData.glyph
                                color: Config.settings.bar.launcherIconName === modelData.name
                                       ? root.controlActiveColor : root.foregroundColor
                                font.family: modelData.font
                                font.pixelSize: 22
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            Caption {
                                width: parent.width
                                text: modelData.name
                                font.pixelSize: 8
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideRight
                            }
                        }

                        MouseArea {
                            id: iconChoiceMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.selectLauncherIcon(modelData)
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }
            }

            Caption {
                Layout.fillWidth: true
                text: "Using " + Config.settings.bar.launcherIconName
                color: root.secondaryColor
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Rectangle {
        x: panel.x
        y: panel.y
        width: panel.width
        height: panel.height
        visible: root.audioMode
        z: 25
        radius: panel.radius
        color: root.panelColor
        border.width: 1
        border.color: root.shellOutlineColor
        clip: true

        MouseArea { anchors.fill: parent; onClicked: {} }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 34
                spacing: 8

                ToggleTile {
                    Layout.preferredWidth: 34
                    Layout.preferredHeight: 34
                    active: false
                    activeColor: root.raisedColor
                    icon: "\ue5c4"
                    tooltipText: "Back"
                    onClicked: root.closeAudioDevices()
                }

                Body {
                    Layout.fillWidth: true
                    text: "Audio outputs"
                    color: root.controlActiveColor
                    font.pixelSize: 15
                    font.bold: true
                }

                ToggleTile {
                    Layout.preferredWidth: 34
                    Layout.preferredHeight: 34
                    active: AudioSystem.muted
                    activeColor: root.dangerColor
                    icon: AudioSystem.muted ? "\ue04f" : "\ue050"
                    tooltipText: AudioSystem.muted ? "Unmute" : "Mute"
                    onClicked: AudioSystem.muted = !AudioSystem.muted
                }

                ToggleTile {
                    Layout.preferredWidth: 34
                    Layout.preferredHeight: 34
                    active: false
                    activeColor: root.raisedColor
                    icon: "\ue5d5"
                    tooltipText: "Refresh outputs"
                    enabled: !root.audioScanning
                    onClicked: if (!audioDeviceQuery.running) audioDeviceQuery.running = true
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                radius: 10
                color: root.surfaceColor
                border.width: 1
                border.color: root.contentOutlineColor

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 10

                    IconText {
                        Layout.preferredWidth: 22
                        text: AudioSystem.muted ? "\ue04f" : "\ue050"
                        pixel: 18
                        color: AudioSystem.muted ? root.dangerColor : root.controlActiveColor
                    }

                    Slider {
                        id: audioVolumeSlider
                        Layout.fillWidth: true
                        from: 0
                        to: 1
                        value: AudioSystem.volume
                        onMoved: AudioSystem.volume = value

                        background: Rectangle {
                            x: audioVolumeSlider.leftPadding
                            y: audioVolumeSlider.topPadding + audioVolumeSlider.availableHeight / 2 - height / 2
                            width: audioVolumeSlider.availableWidth
                            height: 4
                            radius: 2
                            color: root.outlineColor

                            Rectangle {
                                width: audioVolumeSlider.visualPosition * parent.width
                                height: parent.height
                                radius: parent.radius
                                color: root.controlActiveColor
                            }
                        }

                        handle: Rectangle {
                            x: audioVolumeSlider.leftPadding + audioVolumeSlider.visualPosition * (audioVolumeSlider.availableWidth - width)
                            y: audioVolumeSlider.topPadding + audioVolumeSlider.availableHeight / 2 - height / 2
                            width: 14
                            height: 14
                            radius: 7
                            color: root.foregroundColor
                            border.width: 2
                            border.color: root.controlActiveColor
                        }
                    }

                    Caption {
                        Layout.preferredWidth: 36
                        text: Math.round(AudioSystem.volume * 100) + "%"
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }

            Caption {
                Layout.fillWidth: true
                Layout.preferredHeight: visible ? 22 : 0
                visible: root.audioScanning || root.audioError.length > 0 || root.audioDevices.length === 0
                text: root.audioScanning ? "Finding audio outputs…"
                     : (root.audioError.length > 0 ? root.audioError : "No audio outputs found")
                color: root.audioError.length > 0 ? root.dangerColor : root.secondaryColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 6
                model: root.audioDevices

                delegate: Rectangle {
                    required property var modelData
                    width: ListView.view.width
                    height: 52
                    radius: 10
                    color: outputMouse.containsMouse ? root.raisedColor : root.surfaceColor
                    border.width: 1
                    border.color: modelData.active ? root.controlActiveColor : root.contentOutlineColor

                    IconText {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: "\ue1ff"
                        pixel: 19
                        color: modelData.active ? root.controlActiveColor : root.foregroundColor
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.leftMargin: 46
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 3

                        Body {
                            width: parent.width
                            text: modelData.description
                            font.pixelSize: 11
                            font.bold: modelData.active
                            elide: Text.ElideRight
                        }

                        Caption {
                            width: parent.width
                            text: modelData.active ? "Current output" : (modelData.state === "RUNNING" ? "In use · click to select" : "Click to select")
                            color: modelData.active ? root.controlActiveColor : root.secondaryColor
                        }
                    }

                    MouseArea {
                        id: outputMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.selectAudioDevice(modelData.name)
                    }
                }
            }

            Caption {
                Layout.fillWidth: true
                text: AudioSystem.audioDeviceName
                color: root.secondaryColor
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideMiddle
            }
        }
    }

    Item {
        anchors.fill: parent
        visible: root.pickerVisible
        z: 3

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.18)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.closePicker()
        }

        Rectangle {
            anchors.centerIn: parent
            width: Math.min(640, root.width - 24)
            height: Math.min(460, root.height - 24)
            radius: 10
            color: root.surfaceColor
            border.width: 1
            border.color: root.contentOutlineColor
            z: 1
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Body {
                        Layout.fillWidth: true
                        text: root.selectedPickerTitle()
                        color: "#cba6f7"
                        font.pixelSize: 16
                        elide: Text.ElideRight
                    }

                    ClippingRectangle {
                        Layout.preferredWidth: 42
                        Layout.preferredHeight: 42
                        radius: 21
                        color: "#181825"
                        border.width: 1
                        border.color: root.contentOutlineColor
                        visible: root.pickerMode === "avatar"
                        clip: true

                        Image {
                            anchors.fill: parent
                            source: root.imageSource(root.selectedPickerPath)
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            cache: true
                            smooth: true
                            mipmap: true
                        }

                        IconText {
                            anchors.centerIn: parent
                            text: "\ue7fd"
                            pixel: 20
                            color: "#6c7086"
                            visible: root.selectedPickerPath.length === 0
                        }
                    }

                    ToggleTile {
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 34
                        active: false
                        activeColor: root.raisedColor
                        icon: "\ue5ca"
                        tooltipText: root.pickerMode === "avatar" ? "Apply profile photo" : "Apply wallpaper"
                        enabled: root.selectedPickerPath.length > 0
                        onClicked: root.selectedPickerAccept(root.selectedPickerPath)
                    }

                    ToggleTile {
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 34
                        active: false
                        activeColor: root.raisedColor
                        icon: "\ue3f4"
                        tooltipText: "Use default wallpaper"
                        visible: root.pickerMode === "wallpaper"
                        onClicked: root.applyDefaultWallpaper()
                    }

                    ToggleTile {
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 34
                        active: false
                        activeColor: root.raisedColor
                        icon: "\ue5cd"
                        tooltipText: "Close"
                        onClicked: root.closePicker()
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    ToggleTile {
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 34
                        active: false
                        activeColor: root.raisedColor
                        icon: "\ue88a"
                        tooltipText: "Home"
                        onClicked: root.pickerFolder = "file://" + root.homeDirectory
                    }

                    ToggleTile {
                        Layout.preferredWidth: 34
                        Layout.preferredHeight: 34
                        active: false
                        activeColor: root.raisedColor
                        icon: "\ue5d8"
                        tooltipText: "Parent folder"
                        enabled: folderModel.folder !== folderModel.parentFolder
                        onClicked: root.pickerFolder = folderModel.parentFolder
                    }

                    Caption {
                        Layout.fillWidth: true
                        text: root.pickerFolder.replace(/^file:\/\//, "")
                        elide: Text.ElideMiddle
                    }
                }

                FolderListModel {
                    id: folderModel
                    folder: root.pickerFolder
                    showDirs: true
                    showDotAndDotDot: false
                    nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp", "*.bmp", "*.gif"]
                    sortField: FolderListModel.Name
                }

                GridView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: folderModel
                    cellWidth: 120
                    cellHeight: 118

                    delegate: Rectangle {
                        width: 112
                        height: 110
                        radius: 8
                        color: !model.fileIsDir && root.selectedPickerPath === model.filePath ? root.outlineColor : (pickerItemMouse.containsMouse ? root.raisedColor : root.surfaceColor)
                        border.width: 1
                        border.color: root.contentOutlineColor

                        ClippingRectangle {
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.topMargin: 5
                            width: root.pickerMode === "avatar" ? 78 : parent.width - 10
                            height: 78
                            radius: root.pickerMode === "avatar" ? 39 : 6
                            color: "#181825"
                            clip: true

                            Image {
                                id: pickerThumbnail
                                anchors.fill: parent
                                source: model.fileIsDir ? "" : String(model.fileUrl || "")
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                cache: true
                                smooth: true
                                mipmap: true
                                sourceSize.width: 180
                                sourceSize.height: 140
                                opacity: !model.fileIsDir && status === Image.Ready ? 1 : 0

                                Behavior on opacity {
                                    NumberAnimation { duration: 120 }
                                }
                            }

                            IconText {
                                anchors.centerIn: parent
                                text: model.fileIsDir ? "\uf07b" : "\uf03e"
                                pixel: model.fileIsDir ? 28 : 22
                                color: model.fileIsDir ? "#cba6f7" : "#cdd6f4"
                                visible: model.fileIsDir || pickerThumbnail.status !== Image.Ready
                            }
                        }

                        Caption {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.leftMargin: 6
                            anchors.rightMargin: 6
                            anchors.bottomMargin: 6
                            text: model.fileName
                            color: "#cdd6f4"
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                        }

                        MouseArea {
                            id: pickerItemMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (model.fileIsDir) {
                                    root.pickerFolder = model.fileUrl;
                                } else {
                                    root.selectedPickerPath = model.filePath;
                                }
                            }
                        }
                    }
                }

                Caption {
                    Layout.fillWidth: true
                    Layout.preferredHeight: visible ? 24 : 0
                    visible: folderModel.count === 0
                    text: "No images in this folder"
                    color: root.foregroundColor
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

    component Card: Rectangle {
        id: card

        default property alias content: slot.data

        radius: 12
        color: root.surfaceColor
        border.width: 0

        Item {
            id: slot
            anchors.fill: parent
        }

        Rectangle {
            z: 100
            anchors.fill: parent
            radius: card.radius
            color: "transparent"
            border.width: 1
            border.color: root.contentOutlineColor
        }
    }

    component Body: Text {
        font.family: fontGgSans.name
        font.pixelSize: 12
        color: root.foregroundColor
        renderType: Text.NativeRendering
    }

    component Caption: Text {
        font.family: fontGgSans.name
        font.pixelSize: 10
        color: root.secondaryColor
        elide: Text.ElideRight
        renderType: Text.NativeRendering
    }

    component IconText: Text {
        property int pixel: 16
        property string iconFamily: "Maple Mono NF"

        font.family: iconFamily
        font.pixelSize: pixel
        color: root.foregroundColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        renderType: Text.NativeRendering
    }

    component IconButton: Rectangle {
        id: button

        property string icon
        signal clicked()
        activeFocusOnTab: true
        Keys.onReturnPressed: clicked()
        Keys.onSpacePressed: clicked()

        radius: Math.min(width, height) / 2
        color: mouse.containsMouse ? root.outlineColor : root.raisedColor
        border.width: 1
        border.color: activeFocus ? root.controlActiveColor : root.outlineColor
        scale: mouse.pressed ? 0.94 : (mouse.containsMouse ? 1.06 : 1)

        Behavior on scale { NumberAnimation { duration: 100 } }

        IconText {
            anchors.fill: parent
            text: button.icon
            pixel: 18
            transform: Translate { x: -1 }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: button.clicked()
        }
    }

    component TinyAction: Rectangle {
        id: tiny

        property string icon
        property string tooltipText: ""
        property bool primary: false
        signal clicked()
        activeFocusOnTab: enabled
        Keys.onReturnPressed: clicked()
        Keys.onSpacePressed: clicked()

        width: primary ? 30 : 28
        height: 26
        radius: width / 2
        color: mouse.containsMouse ? root.outlineColor : (primary ? root.controlActiveColor : root.raisedColor)
        border.width: 1
        border.color: mouse.containsMouse ? root.foregroundColor : (primary ? root.controlActiveColor : root.outlineColor)
        scale: mouse.pressed ? 0.92 : (mouse.containsMouse ? 1.08 : 1)
        opacity: enabled ? 1 : 0.4

        Behavior on scale { NumberAnimation { duration: 100 } }

        Rectangle {
            z: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            anchors.bottomMargin: 6
            width: tinyTooltipLabel.implicitWidth + 14
            height: 22
            radius: 7
            color: "#181825"
            border.width: 1
            border.color: root.outlineColor
            visible: mouse.containsMouse && tiny.tooltipText.length > 0

            Caption {
                id: tinyTooltipLabel
                anchors.centerIn: parent
                text: tiny.tooltipText
                color: "#cdd6f4"
                font.pixelSize: 8
            }
        }

        IconText {
            anchors.fill: parent
            text: tiny.icon
            iconFamily: "Material Symbols Sharp Filled 36pt"
            pixel: primary ? 13 : 12
            color: primary ? root.surfaceColor : "#cdd6f4"
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            enabled: tiny.enabled
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: tiny.clicked()
        }
    }

    component ToggleTile: Rectangle {
        id: toggle

        property string icon
        property string tooltipText: ""
        property bool active
        property color activeColor: root.controlActiveColor
        signal clicked()
        activeFocusOnTab: enabled
        Keys.onReturnPressed: clicked()
        Keys.onSpacePressed: clicked()

        radius: Math.min(width, height) / 2
        color: active ? activeColor : root.raisedColor
        border.width: 1
        border.color: activeFocus || active ? activeColor : (mouse.containsMouse ? root.foregroundColor : root.outlineColor)
        scale: mouse.pressed ? 0.92 : (mouse.containsMouse ? 1.06 : 1)

        Behavior on scale { NumberAnimation { duration: 100 } }

        Rectangle {
            z: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            anchors.bottomMargin: 8
            width: tooltipLabel.implicitWidth + 16
            height: 24
            radius: 7
            color: "#181825"
            border.width: 1
            border.color: root.outlineColor
            visible: mouse.containsMouse && toggle.tooltipText.length > 0

            Caption {
                id: tooltipLabel
                anchors.centerIn: parent
                text: toggle.tooltipText
                color: "#cdd6f4"
                font.pixelSize: 9
            }
        }

        IconText {
            anchors.fill: parent
            text: toggle.icon
            iconFamily: "Material Symbols Sharp Filled 36pt"
            pixel: 15
            color: active ? root.panelColor : root.foregroundColor
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: toggle.clicked()
        }
    }

    component RadioSwitch: Rectangle {
        id: radioSwitch

        property bool checked: false
        property bool available: true
        signal toggled()

        Layout.preferredWidth: 46
        Layout.preferredHeight: 26
        radius: height / 2
        color: checked ? root.controlActiveColor : root.raisedColor
        border.width: 1
        border.color: checked ? root.controlActiveColor : root.outlineColor
        activeFocusOnTab: true
        Keys.onReturnPressed: toggled()
        Keys.onSpacePressed: toggled()

        Rectangle {
            width: 20
            height: 20
            radius: 10
            x: radioSwitch.checked ? parent.width - width - 3 : 3
            anchors.verticalCenter: parent.verticalCenter
            color: radioSwitch.checked ? root.panelColor : root.foregroundColor

            Behavior on x { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: radioSwitch.toggled()
        }
    }

    component DockIcon: Rectangle {
        id: dockIcon

        property string icon
        property color tint
        signal clicked()
        activeFocusOnTab: true
        Keys.onReturnPressed: clicked()
        Keys.onSpacePressed: clicked()

        Layout.preferredWidth: 18
        Layout.preferredHeight: 22
        radius: 5
        color: mouse.containsMouse ? root.outlineColor : "transparent"
        scale: mouse.pressed ? 0.92 : (mouse.containsMouse ? 1.12 : 1)

        Behavior on scale { NumberAnimation { duration: 100 } }

        IconText {
            anchors.fill: parent
            text: dockIcon.icon
            pixel: 12
            color: dockIcon.tint
            transform: Translate { x: -1 }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: dockIcon.clicked()
        }
    }

    component ChoiceButton: Rectangle {
        id: choiceButton

        property string label: ""
        property string detail: ""
        property bool selected: false
        signal clicked()

        Layout.preferredHeight: 40
        radius: 9
        color: selected ? root.raisedColor : (choiceMouse.containsMouse ? root.raisedColor : root.surfaceColor)
        border.width: 1
        border.color: selected ? root.controlActiveColor : root.contentOutlineColor

        Column {
            anchors.centerIn: parent
            width: parent.width - 10
            spacing: 1

            Body {
                width: parent.width
                text: choiceButton.label
                color: choiceButton.selected ? root.controlActiveColor : root.foregroundColor
                font.pixelSize: 10
                font.bold: choiceButton.selected
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }

            Caption {
                width: parent.width
                visible: choiceButton.detail.length > 0
                text: choiceButton.detail
                font.pixelSize: 7
                horizontalAlignment: Text.AlignHCenter
            }
        }

        MouseArea {
            id: choiceMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: choiceButton.clicked()
        }
    }

    component OptionToggle: Rectangle {
        id: optionToggle

        property string label: ""
        property string detail: ""
        property bool checked: false
        property bool available: true
        signal toggled()

        Layout.fillWidth: true
        Layout.preferredHeight: 36
        radius: 9
        color: optionMouse.containsMouse ? root.raisedColor : root.surfaceColor
        border.width: 1
        border.color: checked ? root.controlActiveColor : root.contentOutlineColor
        opacity: available ? 1 : 0.48

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 8
            spacing: 8

            Column {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 1
                Body { text: optionToggle.label; font.pixelSize: 10; font.bold: optionToggle.checked }
                Caption { text: optionToggle.detail; font.pixelSize: 8 }
            }

            RadioSwitch { checked: optionToggle.checked; onToggled: optionToggle.toggled() }
        }

        MouseArea {
            id: optionMouse
            anchors.fill: parent
            enabled: optionToggle.available
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: optionToggle.toggled()
        }
    }

    component SettingSlider: RowLayout {
        id: settingSlider

        property string label: ""
        property real from: 0
        property real to: 100
        property real value: 0
        property real stepSize: 1
        property real multiplier: 1
        property string suffix: ""
        signal changed(real value)

        Layout.fillWidth: true
        Layout.preferredHeight: 34
        spacing: 8

        Body {
            Layout.preferredWidth: 78
            text: settingSlider.label
            color: "#cdd6f4"
            font.pixelSize: 10
        }

        Slider {
            id: control
            Layout.fillWidth: true
            from: settingSlider.from
            to: settingSlider.to
            value: settingSlider.value
            stepSize: settingSlider.stepSize
            onMoved: settingSlider.changed(value)

            background: Rectangle {
                x: control.leftPadding
                y: control.topPadding + control.availableHeight / 2 - height / 2
                width: control.availableWidth
                height: 4
                radius: 2
                color: root.outlineColor

                Rectangle {
                    width: control.visualPosition * parent.width
                    height: parent.height
                    radius: parent.radius
                    color: "#cba6f7"
                }
            }

            handle: Rectangle {
                x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
                y: control.topPadding + control.availableHeight / 2 - height / 2
                width: 14
                height: 14
                radius: 7
                color: control.pressed ? "#f5c2e7" : "#cba6f7"
                border.width: 1
                border.color: root.surfaceColor
            }
        }

        Caption {
            Layout.preferredWidth: 42
            text: Math.round(settingSlider.value * settingSlider.multiplier) + settingSlider.suffix
            color: "#a6adc8"
            horizontalAlignment: Text.AlignRight
        }
    }

    component PickerButton: Button {
        id: pickerButton

        implicitWidth: 46
        implicitHeight: 34

        contentItem: Body {
            anchors.centerIn: parent
            text: pickerButton.text
            color: pickerButton.enabled ? "#cdd6f4" : "#6c7086"
        }

        background: Rectangle {
            anchors.fill: parent
            radius: 6
            color: pickerButton.hovered ? root.outlineColor : "#181825"
            border.width: 1
            border.color: pickerButton.hovered ? "#cba6f7" : root.outlineColor
        }
    }
}
