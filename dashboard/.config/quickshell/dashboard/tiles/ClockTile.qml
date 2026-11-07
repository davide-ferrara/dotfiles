import QtQuick
import QtQuick.Layouts
import ".."
StatCard {
    id: root
    property var shell
    property date now: new Date()
    label: "Clock"
    theme: shell._theme
    Timer { interval: 1000; repeat: true; running: true; onTriggered: root.now = new Date() }
    Text { textFormat: Text.PlainText; text: Qt.formatTime(root.now, "HH:mm"); color: shell._fg(); font.weight: Font.Medium; font.pixelSize: 38 }
    Text { textFormat: Text.PlainText; text: Qt.formatDate(root.now, "dddd, d MMMM yyyy"); color: shell._fg(0.8); font.weight: Font.Medium; font.pixelSize: 12 }
}
