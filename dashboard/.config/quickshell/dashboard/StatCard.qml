import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property string label: ""
    property bool centerContent: false
    readonly property string headerIcon: {
        const text = label.toLowerCase()
        if (text.startsWith("cpu") || text.startsWith("gpu")) return "⚙"
        if (text.startsWith("memory")) return "▦"
        if (text.startsWith("disk")) return "◉"
        if (text.startsWith("battery")) return "▰"
        if (text.startsWith("network") || text.startsWith("ping")) return "↗"
        if (text.startsWith("system updates")) return "⟳"
        if (text.startsWith("clock")) return "◷"
        if (text.startsWith("calendar")) return "▦"
        if (text.startsWith("weather")) return "☀"
        if (text.startsWith("sun")) return "◒"
        if (text.startsWith("media")) return "♫"
        if (text.startsWith("hacker news")) return "H"
        if (text.startsWith("omarchy news")) return "O"
        if (text.startsWith("focus")) return "◴"
        return "◆"
    }
    // Live Theme instance (see Theme.qml), shared from shell.qml - colors
    // the glass fill and label from the active Omarchy theme when set,
    // otherwise falls back to a neutral dark-glass default.
    property var theme: null
    default property alias content: contentArea.data
    // Optional small control pinned to the right end of the label row
    // (e.g. the Focus tile's settings cog).
    property Component headerAccessory: null

    // True while the pointer is anywhere over the card - used by tiles that
    // want a control to appear only on hover. Passive, so it never steals
    // events from the card's own interactive bits.
    readonly property bool hovered: cardHover.hovered
    HoverHandler { id: cardHover }

    implicitWidth: 296
    implicitHeight: contentArea.y + contentArea.implicitHeight + 12

    // Glass background - tinted from the theme's own background color so
    // it reads as "whitish glass" on light themes and "blackish glass" on
    // dark ones, instead of always being a flat dark tint.
    Rectangle {
        anchors.fill: parent
        radius: 16
        color: root.theme
               ? Qt.rgba(root.theme.background.r, root.theme.background.g, root.theme.background.b, root.theme.glassAlpha)
               : Qt.rgba(0.08, 0.08, 0.10, 0.5)
        // Optional hairline outline - toggled from the settings modal.
        border.width: (root.theme && root.theme.glassBorder) ? 1 : 0
        border.color: root.theme
               ? Qt.rgba(root.theme.foreground.r, root.theme.foreground.g, root.theme.foreground.b, 0.12)
               : Qt.rgba(1, 1, 1, 0.10)
    }

    // Card label
    Text {
        id: headerGlyph
        anchors { left: parent.left; leftMargin: 14; verticalCenter: cardLabel.verticalCenter }
        width: 17
        horizontalAlignment: Text.AlignHCenter
        textFormat: Text.PlainText
        text: root.headerIcon
        color: root.theme ? root.theme.accent : "#7aa2f7"
        font.pixelSize: 14
        font.weight: Font.DemiBold
    }
    Text {
        id: cardLabel
        anchors { top: parent.top; left: headerGlyph.right; right: parent.right; topMargin: 12; leftMargin: 8; rightMargin: 32 }
        textFormat: Text.PlainText
        text: root.label.toUpperCase()
        elide: Text.ElideRight
        color: root.theme
               ? Qt.rgba(root.theme.foreground.r, root.theme.foreground.g, root.theme.foreground.b, 0.55)
               : Qt.rgba(1, 1, 1, 0.45)
        font.weight: Font.Medium; font.pixelSize: 10
        font.letterSpacing: 1.2

    }

    // Optional right-aligned control on the label row.
    Loader {
        sourceComponent: root.headerAccessory
        anchors {
            right: parent.right; rightMargin: 12
            verticalCenter: cardLabel.verticalCenter
        }
    }

    // Content goes here (via default property)
    ColumnLayout {
        id: contentArea
        anchors {
            top: cardLabel.bottom
            topMargin: root.centerContent ? Math.max(8, (root.height - cardLabel.y - cardLabel.height - contentArea.implicitHeight) / 2) : 8
            left: parent.left; leftMargin: 14
            right: parent.right; rightMargin: 14
        }
        spacing: 6
    }
}
