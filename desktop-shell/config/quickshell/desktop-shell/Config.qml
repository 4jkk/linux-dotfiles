pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    //*=======================================================================*/
    // READ THIS NOTE:
    // Simply add to this list in order to create your
    // own color schemes, they will automatically show up in the theme picker.
    property var colors: themes[themes[settings.currentTheme] == null ? 'catppuccin' : settings.currentTheme]
    property var themes: {
        "catppuccin": {
            "base": "#1e1e2e",
            "shadow": "#181825",
            "highlight": "#313244",
            "urgent": "#fab387",
            "accent": "#cba6f7",
            "accentDark": "#6c7086",
            "text": "#1e1e2e",
            "textLight": "#cdd6f4",
            "outline": "#45475a",
            "outlineGradientFade": "#181825",
            "defaultWallpaperPath": "",
            "danger": "#f38ba8",
            "warning": "#f9e2af",
            "cbodyBackground": "#cba6f7",
            "cbodyBackgroundShadow": "#9399b2",
            "cbodyMoonBackground": "#45475a",
            "cbodyMoonBackgroundShadow": "#313244",
            "cbodyStroke": "#11111b",
            "cbodyPowerMenu": "#f38ba8",
            "cbodyThemingMenu": "#cba6f7",
            "cbodyFavoriteApps": "#89b4fa",
            "cbodyMainMenu": "#a6e3a1",
            "glassTintColor": "#cba6f7",
            "appLauncherBackground": "#181825",
            "patternLineColor": "#45475a",
            "humorWet": "#89b4fa",
            "humorDry": "#f9e2af",
            "humorCold": "#89dceb",
            "humorHot": "#f38ba8",
            "elementAir": "#cdd6f4",
            "elementWater": "#89b4fa",
            "elementEarth": "#a6e3a1",
            "elementFire": "#fab387"
        },
        "gruvbox-dark-hard": {
            "base": "#1d2021",
            "shadow": "#141617",
            "highlight": "#3c3836",
            "urgent": "#fe8019",
            "accent": "#d79921",
            "accentDark": "#665c54",
            "text": "#1d2021",
            "textLight": "#ebdbb2",
            "outline": "#504945",
            "outlineGradientFade": "#282828",
            "defaultWallpaperPath": "",
            "danger": "#fb4934",
            "warning": "#fabd2f",
            "cbodyBackground": "#d79921",
            "cbodyBackgroundShadow": "#b57614",
            "cbodyMoonBackground": "#504945",
            "cbodyMoonBackgroundShadow": "#3c3836",
            "cbodyStroke": "#1d2021",
            "cbodyPowerMenu": "#cc241d",
            "cbodyThemingMenu": "#b16286",
            "cbodyFavoriteApps": "#458588",
            "cbodyMainMenu": "#98971a",
            "glassTintColor": "#d79921",
            "appLauncherBackground": "#282828",
            "patternLineColor": "#665c54",
            "humorWet": "#458588",
            "humorDry": "#d5c4a1",
            "humorCold": "#83a598",
            "humorHot": "#cc241d",
            "elementAir": "#ebdbb2",
            "elementWater": "#458588",
            "elementEarth": "#98971a",
            "elementFire": "#d65d0e"
        },
        "helios": {
            "base": "#181818",
            "shadow": "#121212",
            "highlight": "#333333",
            "urgent": "#ff723e",
            "accent": "#fccf8a",
            "accentDark": "#87704f",
            "text": "#121212",
            "textLight": "#d0daed",
            "outline": "#121212",
            "outlineGradientFade": "#161616",
            "defaultWallpaperPath": "",
            "danger": "#fc5870",
            "warning": "#fcd37b",
            "cbodyBackground": "#fccf8a",
            "cbodyBackgroundShadow": "#d1a67b",
            "cbodyMoonBackground": "#484a5e",
            "cbodyMoonBackgroundShadow": "#5e5e5e",
            "cbodyStroke": "#000000",
            "cbodyPowerMenu": "#fccf8a",
            "cbodyThemingMenu": "#a0675d",
            "cbodyFavoriteApps": "#5e5e5e",
            "cbodyMainMenu": "#666c93",
            "glassTintColor": "#fce2ab",
            "appLauncherBackground": "#252525",
            "patternLineColor": "#87704f",
            "humorWet": "#425682",
            "humorDry": "#c4a78f",
            "humorCold": "#92bbcc",
            "humorHot": "#c44444",
            "elementAir": "#ccdde2",
            "elementWater": "#6f8ebc",
            "elementEarth": "#473e39",
            "elementFire": "#c15555"
        },
        "eris": {
            "base": "#1b1c1e",
            "shadow": "#121212",
            "highlight": "#2f2f33",
            "urgent": "#ff723e",
            "accent": "#c7cfe5",
            "accentDark": "#989daa",
            "text": "#121212",
            "textLight": "#b6aae2",
            "outline": "#121212",
            "danger": "#fc5870",
            "warning": "#fcd37b",
            "cbodyBackground": "#d2dddc",
            "cbodyBackgroundShadow": "#97a09f",
            "cbodyMoonBackground": "#484a5e",
            "cbodyMoonBackgroundShadow": "#5e5e5e",
            "cbodyStroke": "#000000",
            "cbodyPowerMenu": "#d2dddc",
            "cbodyThemingMenu": "#767d7f",
            "cbodyFavoriteApps": "#536868",
            "cbodyMainMenu": "#68877f",
            "glassTintColor": "#b9c5c9",
            "appLauncherBackground": "#252525",
            "patternLineColor": "#505160",
            "humorWet": "#425682",
            "humorDry": "#c4a78f",
            "humorCold": "#92bbcc",
            "humorHot": "#c44444",
            "elementAir": "#ccdde2",
            "elementWater": "#6f8ebc",
            "elementEarth": "#473e39",
            "elementFire": "#c15555"
        },
        "priapus": {
            "base": "#1f211e",
            "shadow": "#121410",
            "highlight": "#393d2d",
            "urgent": "#ff723e",
            "accent": "#a7b777",
            "accentDark": "#747c5c",
            "text": "#121212",
            "textLight": "#d0daed",
            "outline": "#141612",
            "danger": "#fc5870",
            "warning": "#fcd37b",
            "cbodyBackground": "#f2efb3",
            "cbodyBackgroundShadow": "#aaa87c",
            "cbodyMoonBackground": "#484a5e",
            "cbodyMoonBackgroundShadow": "#5e5e5e",
            "cbodyStroke": "#000000",
            "cbodyPowerMenu": "#f2d793",
            "cbodyThemingMenu": "#666c75",
            "cbodyFavoriteApps": "#5b5050",
            "cbodyMainMenu": "#5b6b54",
            "glassTintColor": "#a6bf85",
            "appLauncherBackground": "#252525",
            "patternLineColor": "#4a5437",
            "humorWet": "#425682",
            "humorDry": "#cdce8c",
            "humorCold": "#bcd8d6",
            "humorHot": "#c44444",
            "elementAir": "#c7e0ca",
            "elementWater": "#6f8ebc",
            "elementEarth": "#3e3f2f",
            "elementFire": "#c15555"
        },
        "eros": {
            "base": "#15101c",
            "shadow": "#110c16",
            "highlight": "#2c243d",
            "urgent": "#ff723e",
            "accent": "#fccb7b",
            "accentDark": "#87704f",
            "text": "#121212",
            "textLight": "#d0daed",
            "outline": "#0c0b0c",
            "danger": "#eda1a6",
            "warning": "#fcd37b",
            "cbodyBackground": "#f9997f",
            "cbodyBackgroundShadow": "#b78487",
            "cbodyMoonBackground": "#484a5e",
            "cbodyMoonBackgroundShadow": "#5e5e5e",
            "cbodyStroke": "#000000",
            "cbodyPowerMenu": "#f9997f",
            "cbodyThemingMenu": "#705a7a",
            "cbodyFavoriteApps": "#ad7082",
            "cbodyMainMenu": "#53475e",
            "glassTintColor": "#3c2d66",
            "appLauncherBackground": "#252525",
            "patternLineColor": "#725c3b",
            "humorWet": "#425682",
            "humorDry": "#c4a78f",
            "humorCold": "#92bbcc",
            "humorHot": "#c44444",
            "elementAir": "#ccdde2",
            "elementWater": "#6f8ebc",
            "elementEarth": "#473e39",
            "elementFire": "#c15555"
        },
        "hades": {
            "base": "#181818",
            "shadow": "#121212",
            "highlight": "#333333",
            "urgent": "#ff723e",
            "accent": "#d1ceca",
            "accentDark": "#969593",
            "text": "#eaeaea",
            "textLight": "#f7f8f9",
            "outline": "#e3e7e8",
            "danger": "#aa3a3a",
            "warning": "#c6c479",
            "cbodyBackground": "#181818",
            "cbodyBackgroundShadow": "#121212",
            "cbodyMoonBackground": "#484a5e",
            "cbodyMoonBackgroundShadow": "#5e5e5e",
            "cbodyStroke": "#eaeaea",
            "cbodyPowerMenu": "#181818",
            "cbodyThemingMenu": "#181818",
            "cbodyFavoriteApps": "#181818",
            "cbodyMainMenu": "#181818",
            "glassTintColor": "#d7dddb",
            "appLauncherBackground": "#252525",
            "patternLineColor": "#7f7f7f",
            "humorWet": "#425682",
            "humorDry": "#c6c479",
            "humorCold": "#8da5c9",
            "humorHot": "#c44444",
            "elementAir": "#cccccc",
            "elementWater": "#66929e",
            "elementEarth": "#423f3d",
            "elementFire": "#c15555"
        }
    }

    enum SystemPopup {
        Startmenu,
        ThemePicker,
        AppLauncher,
        ControlCenter,
        None
    }
    enum SidebarPopup {
        PowerMenu,
        FavoriteAppsMenu,
        ThemingMenu,
        MainMenu,
        None
    }
    // TODO: Finish adding all the other widgets
    readonly property var widgetTypes: ["Weather"]
    readonly property var widgetPaths: {
        "Weather": "WeatherWidget.qml"
        //"CPUTemp": "CPUTemperatureWidget.qml",
        //"GPUTemp": "GPUTemperatureWidget.qml",
        //"RAM": "RAMWidget.qml",
        //"Clock": "ClockWidget.qml",
        //"TheDate": "DateWidget.qml"
    }

    // Weather stuff
    property var weatherData: undefined
    property bool weatherLoading: false
    property string weatherError: ""
    function fetchWeatherData() {
        var xmlhttp = new XMLHttpRequest();
        weatherLoading = true;
        weatherError = "";
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState === XMLHttpRequest.DONE) {
                weatherLoading = false;
                if (xmlhttp.status == 200) {
                    try {
                        weatherData = JSON.parse(xmlhttp.responseText);
                    } catch (error) {
                        weatherError = "Invalid weather response";
                    }
                } else {
                    weatherError = "Weather unavailable";
                }
            }
        };

        const location = (settings.openWeatherMap.city || "").trim();
        const url = `https://wttr.in/${encodeURIComponent(location)}?format=j1`;

        xmlhttp.open("GET", url, true);
        xmlhttp.send();
    }
    Timer {
        interval: 10 * 60 * 1000
        running: Config.settings.openWeatherMap.enableWeather
        repeat: Config.settings.openWeatherMap.enableWeather
        triggeredOnStart: Config.settings.openWeatherMap.enableWeather
        onTriggered: Config.fetchWeatherData()
    }

    function toggleFavoriteApp(appName: string, exec: list<string>, iconPath: string) {
        let updated = Object.assign({}, favoriteApps);
        if (favoriteApps[appName] != null) {
            delete favoriteApps[appName];
            return;
        }
        if (!favoriteApps[appName]) {
            updated[appName] = {};
            favoriteApps = updated;
        }
        updated[appName] = {
            "name": appName,
            "execCommand": exec,
            "icon": iconPath
        };
        favoriteApps = updated;
    }
    property alias favoriteApps: favoriteAppsAdapter.apps
    FileView {
        path: Qt.resolvedUrl("./favoriteapps.json")
        // when changes are made on disk, reload the file's content
        watchChanges: true
        onFileChanged: reload()
        // when changes are made to properties in the adapter, save them
        onAdapterUpdated: writeAdapter()

        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
            }
        }
        JsonAdapter {
            id: favoriteAppsAdapter

            // IGNORE WARNING, do not wrap in ()
            property var apps: ({})
        }
    }
    //Widgets
    function addWidget(monitorName: string, widgetType: int, widgetName: string, x: int, y: int, enableBackground: bool) {
        let updated = Object.assign({}, widgets);
        if (!widgets[monitorName]) {
            updated[monitorName] = {};
            widgets = updated;
        }
        updated[monitorName] = Object.assign({}, updated[monitorName]);
        updated[monitorName][Object.keys(updated[monitorName]).length] = {
            "widgetName": widgetName,
            "widgetType": widgetType,
            "x": x,
            "y": y,
            "enableBackground": enableBackground,
            "monitorName": monitorName,
            "widgetId": Object.keys(updated[monitorName]).length.toString()
        };
        widgets = updated;
    }
    function updateWidget(monitorName: string, widgetId: int, widgetName: string, x: int, y: int, enableBackground: bool, widgetType: int) {
        let updated = Object.assign({}, widgets);
        if (!widgets[monitorName]) {
            console.error("Monitor not found!");
            return;
        }
        updated[monitorName] = Object.assign({}, updated[monitorName]);
        updated[monitorName][widgetId] = {
            "widgetName": widgetName,
            "widgetType": widgetType,
            "x": x,
            "y": y,
            "enableBackground": enableBackground,
            "monitorName": monitorName,
            "widgetId": widgetId
        };
        widgets = updated;
    }
    function removeWidget(monitorName: string, widgetId: string) {
        let updated = Object.assign({}, widgets);
        delete updated[monitorName][widgetId];
        widgets = updated;
    }
    property alias widgets: widgetsAdapter.monitors
    FileView {
        path: Qt.resolvedUrl("./widgets.json")
        // when changes are made on disk, reload the file's content
        watchChanges: true
        onFileChanged: reload()
        // when changes are made to properties in the adapter, save them
        onAdapterUpdated: writeAdapter()

        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
            }
        }
        JsonAdapter {
            id: widgetsAdapter

            // IGNORE WARNING, do not wrap in ()
            property var monitors: ({})
        }
    }

    property bool openSettingsWindow: false
    property bool openControlCenter: false
    property var controlCenterScreen: null
    property bool openCalendar: false
    property var calendarScreen: null
    property bool openNotificationCenter: false
    property int notificationCount: 0
    property alias settings: settingsJsonAdapter.settings
    FileView {
        path: Qt.resolvedUrl("./settings.json")
        // when changes are made on disk, reload the file's content
        watchChanges: true
        onFileChanged: reload()
        // when changes are made to properties in the adapter, save them
        onAdapterUpdated: writeAdapter()

        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
            }
        }

        JsonAdapter {
            id: settingsJsonAdapter
            property JsonObject settings: JsonObject {
                property string version: "0.1"
                property bool militaryTimeClockFormat: true
                property string currentTheme: "catppuccin"
                property int defaultWindowRadius: 12
                property bool appLauncherBackground: true
                property JsonObject openWeatherMap: JsonObject {
                    property string apiKey: ""
                    property string city: ""
                    property string unit: "metric" //standard = kelvin, metric = c, imperial = F
                    property bool enableWeather: true
                }
                property JsonObject execCommands: JsonObject {
                    property string terminal: "kitty"
                    property string files: "nemo"
                }
                property JsonObject ui: JsonObject {
                    property string avatarPath: ""
                    property string wallpaperPath: "/home/akk/Downloads/01.jpg"
                    property string shellOutlineColor: "#ff0000"
                }
                property JsonObject bar: JsonObject {
                    property int fontSize: 12
                    property double workspacePadding: 0.032
                    property int trayIconSize: 14
                    property bool monochromeTrayIcons: true
                    property int widthPercent: 50
                    property int height: 26
                    property int offset: 0
                    property int radius: 6
                    property string layoutMode: "compact"
                    property string edgeStyle: "rounded"
                    property bool centerWorkspaces: false
                    property double opacity: 0.8
                    property string textColor: "#cdd6f4"
                    property string launcherIconName: "Arch Linux"
                    property string launcherIconGlyph: "\uf303"
                    property string launcherIconFont: "JetBrainsMono Nerd Font"
                    property bool reduceMotion: false
                    property bool smartTransparency: false
                    property bool scrollVolume: true
                    property bool showNotificationIndicator: false
                    property bool showBatteryIndicator: false
                    property bool showActiveWindow: false
                }
                property JsonObject extras: JsonObject {
                    property bool volumeOsd: true
                    property bool brightnessOsd: false
                    property bool notifications: false
                    property bool clipboardHistory: false
                    property bool wallpaperColors: false
                }
                onCurrentThemeChanged: {
                    console.info("Updated theme to: " + currentTheme);
                }
            }
        }
    }
}
