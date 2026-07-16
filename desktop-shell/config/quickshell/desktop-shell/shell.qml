//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

/* NOTE: CHANGE THESE IF YOU WANT TO USE A DIFFERENT ICON THEME:*/
//@ pragma IconTheme buuf-nestort
//@ pragma Env QS_ICON_THEME=buuf-nestort

import QtQuick
import Quickshell

import "taskbar" as Taskbar
import "popups" as Popups

Scope {
    id: root
    IpcHandler {
        target: "desktopShell"

        function toggleControlCenter(): void {
            Config.controlCenterScreen = Quickshell.screens[0];
            Config.openControlCenter = !Config.openControlCenter;
        }
    }
    FontLoader {
        id: iconFont
        source: "fonts/MaterialSymbolsSharp_Filled_36pt-Regular.ttf"
    }
    FontLoader {
        id: fontMonaco
        source: "fonts/Monaco.ttf"
    }
    FontLoader {
        id: fontCharcoal
        source: "fonts/Charcoal.ttf"
    }
    FontLoader {
        id: fontBoska
        source: "fonts/Boska-Variable.ttf"
    }
    FontLoader {
        id: fontBoskaItalic
        source: "fonts/Boska-VariableItalic.ttf"
    }
    FontLoader {
        id: fontRecia
        source: "fonts/Recia-Variable.ttf"
    }
    FontLoader {
        id: fontReciaItalic
        source: "fonts/Recia-VariableItalic.ttf"
    }
    FontLoader {
        id: fontQuilon
        source: "fonts/Quilon-Variable.ttf"
    }
    FontLoader {
        id: fontDominica
        source: "fonts/DOMINICA.TTF"
    }
    FontLoader {
        id: fontGgSans
        source: "fonts/gg sans Medium.ttf"
    }

    Taskbar.Bar {}
    Popups.ControlCenter {
        id: controlCenter
    }
    Popups.CalendarPopup {}
    Popups.VolumeOsd {}

    Loader {
        active: Config.settings.extras.notifications
        sourceComponent: Component { Popups.NotificationCenter {} }
    }
}
