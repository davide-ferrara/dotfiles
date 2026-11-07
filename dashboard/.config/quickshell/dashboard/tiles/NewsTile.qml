import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."

StatCard {
    id: root
    property var shell
    property string source: "hacker"
    property var stories: []
    property string status: "Loading…"
    property double lastChecked: 0
    label: source === "hacker" ? "Hacker News" : "Omarchy News"
    theme: shell._theme
    Process {
        id: fetcher
        command: ["python3", Qt.resolvedUrl("../news.py").toString().replace(/^file:\/\//, ""), root.source]
        stdout: StdioCollector { id: output }
        onExited: (code, exitStatus) => {
            if (code !== 0) { root.status = "News unavailable"; return }
            try {
                const items = JSON.parse(output.text)
                root.stories = Array.isArray(items) ? items.slice(0, 8) : []
                root.status = root.stories.length ? "" : "No stories available"
            } catch (e) { root.status = "News unavailable" }
        }
    }
    Process { id: opener }
    Timer {
        interval: 60000; repeat: true; running: !shell._dashboardCovered; triggeredOnStart: true
        onTriggered: {
            if (!fetcher.running && Date.now() - root.lastChecked >= 1800000) {
                root.lastChecked = Date.now()
                fetcher.running = true
            }
        }
    }
    Text { visible: root.status !== ""; textFormat: Text.PlainText; text: root.status; color: shell._fg(0.7); font.weight: Font.Medium; font.pixelSize: 12 }
    Repeater {
        model: root.stories
        delegate: Item {
            required property var modelData
            Layout.fillWidth: true
            implicitHeight: 26
            Rectangle {
                id: badge
                anchors { left: parent.left; verticalCenter: parent.verticalCenter }
                width: 22; height: 22; radius: 6
                color: Qt.rgba(theme.accent.r, theme.accent.g, theme.accent.b, hover.containsMouse ? 0.32 : 0.16)
                Text {
                    anchors.centerIn: parent
                    textFormat: Text.PlainText
                    text: root.source === "hacker" ? "H" : "O"
                    color: theme.accent
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                }
            }
            Text {
                id: headline
                anchors { left: badge.right; leftMargin: 10; right: parent.right; verticalCenter: parent.verticalCenter }
                textFormat: Text.PlainText
                text: modelData.title
                color: hover.containsMouse ? theme.accent : shell._fg(0.9)
                font.weight: Font.Medium; font.pixelSize: 12
                wrapMode: Text.NoWrap
                maximumLineCount: 1
                elide: Text.ElideRight
            }
            MouseArea {
                id: hover
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (/^https?:\/\//i.test(modelData.url) && !opener.running) {
                        opener.command = ["xdg-open", modelData.url]
                        opener.running = true
                    }
                }
            }
        }
    }
}
