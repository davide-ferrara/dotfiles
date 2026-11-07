import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."

StatCard {
    id: root
    property var shell
    property string status: "Checking…"
    property string updateState: "checking"
    property string version: "…"
    property double lastChecked: 0
    label: "System updates"
    theme: shell._theme
    centerContent: true
    Process {
        command: ["omarchy", "version"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.version = text.trim().slice(0, 40) || "unknown"
        }
    }
    Process {
        id: checker
        command: ["timeout", "90", "checkupdates"]
        stdout: StdioCollector { id: output }
        onExited: (code, status) => {
            if (code === 0) {
                const count = output.text.trim().split("\n").filter(x => x.length > 0).length
                root.status = count + (count === 1 ? " package available" : " packages available")
                root.updateState = "available"
            } else if (code === 2) {
                root.status = "Up to date"
                root.updateState = "current"
            } else {
                root.status = "Check failed — try again later"
                root.updateState = "error"
            }
        }
    }
    Timer {
        interval: 60000
        repeat: true
        running: !shell._dashboardCovered
        triggeredOnStart: true
        onTriggered: {
            if (!checker.running && Date.now() - root.lastChecked >= 3600000) {
                root.lastChecked = Date.now()
                checker.running = true
            }
        }
    }
    Text {
        textFormat: Text.PlainText; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter
        text: root.updateState === "current" ? "☺" : root.updateState === "available" ? "⬆" : root.updateState === "error" ? "⚠" : "◌"
        color: root.updateState === "error" ? theme.red : theme.accent
        font.pixelSize: 26
    }
    Text { textFormat: Text.PlainText; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; text: root.status; color: shell._fg(); font.weight: Font.Medium; font.pixelSize: 16; wrapMode: Text.Wrap }
    Text { textFormat: Text.PlainText; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; text: "Omarchy " + root.version; color: shell._fg(0.8); font.weight: Font.Medium; font.pixelSize: 11 }
    Text { textFormat: Text.PlainText; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; text: "Official repositories · checked hourly"; color: shell._fg(0.55); font.weight: Font.Medium; font.pixelSize: 10 }
}
