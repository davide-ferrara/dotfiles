import QtQuick
import QtQuick.Layouts
import ".."
StatCard {
    id: root
    property var shell
    property date now: new Date()
    label: "Calendar"
    theme: shell._theme
    Timer { interval: 60000; repeat: true; running: true; onTriggered: root.now = new Date() }
    Text { textFormat: Text.PlainText; text: Qt.formatDate(root.now, "MMMM yyyy"); color: shell._fg(); font.weight: Font.Medium; font.pixelSize: 17 }
    Grid {
        Layout.fillWidth: true
        columns: 7
        rowSpacing: 7
        Repeater {
            model: 49
            delegate: Text {
                required property int index
                readonly property int first: (new Date(root.now.getFullYear(), root.now.getMonth(), 1).getDay() + 6) % 7
                readonly property int day: index - 7 - first + 1
                readonly property int days: new Date(root.now.getFullYear(), root.now.getMonth() + 1, 0).getDate()
                width: parent.width / 7
                horizontalAlignment: Text.AlignHCenter
                textFormat: Text.PlainText
                text: index < 7 ? ["M", "T", "W", "T", "F", "S", "S"][index] : (day > 0 && day <= days ? day : "")
                color: index < 7 ? shell._fg(0.45) : day === root.now.getDate() ? theme.accent : shell._fg(0.8)

                font.weight: Font.Medium; font.pixelSize: 12
            }
        }
    }
}
