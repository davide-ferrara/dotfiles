import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "dff.meteora"

  // Selected from the lyrics supplied by the user. Add favorites here.
  readonly property var reflections: [
    "Sometimes I need to remember just to breathe — Don't Stay",
    "Just take myself back — Don't Stay",
    "I wanna heal, I wanna feel — Somewhere I Belong",
    "I wanna let go of the pain I've felt so long — Somewhere I Belong",
    "Somewhere I belong — Somewhere I Belong",
    "I will break away, I'll find myself today — Somewhere I Belong",
    "I will never know myself until I do this on my own — Somewhere I Belong",
    "No turning back now — Lying From You",
    "Let me take me back my life — Lying From You",
    "One minute you're up top — Hit The Floor",
    "If I could change I would — Easier To Run",
    "If I could stand up and take the blame I would — Easier To Run",
    "I won't be ignored — Faint",
    "I do what I can — Faint",
    "Hear me out now — Faint",
    "I took what I hated and made it a part of me — Figure.09",
    "Give me my space back — Figure.09",
    "I let you go — Figure.09",
    "But now I have some clarity — Breaking The Habit",
    "I'm breaking the habit tonight — Breaking The Habit",
    "I try to catch my breath again — Breaking The Habit",
    "Trying not to break — From The Inside",
    "I won't waste myself on you — From The Inside",
    "Never forget the blood, sweat and tears — Nobody's Listening",
    "The uphill struggle over years — Nobody's Listening",
    "Pain gave me something I could set my sights on — Nobody's Listening",
    "Be more like me and be less like you — Numb",
    "And I know I may end up failing too — Numb"
  ]
  property int offset: 0
  property bool meteoraActive: false
  readonly property int hourIndex: Math.floor(clock.date.getTime() / 3600000)
  readonly property int reflectionIndex: (((hourIndex + offset) % reflections.length) + reflections.length) % reflections.length
  readonly property string entry: reflections[reflectionIndex]
  readonly property int separator: entry.lastIndexOf(" — ")
  readonly property string reflection: separator < 0 ? entry : entry.slice(0, separator)
  readonly property string song: separator < 0 ? "" : entry.slice(separator + 3)

  function advance() {
    offset = (offset + 1) % reflections.length
  }

  implicitWidth: vertical ? 0 : Math.min(label.implicitWidth, 400) + Style.space(16)
  implicitHeight: vertical ? 0 : barSize
  visible: !vertical && meteoraActive

  FileView {
    id: themeFile
    path: Quickshell.env("HOME") + "/.local/state/omarchy/current/theme.name"
    watchChanges: true
    printErrors: false
    onLoaded: root.meteoraActive = text().trim() === "meteora"
    onLoadFailed: root.meteoraActive = false
    onFileChanged: reload()
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    labelVisible: false
    hasVisualContent: root.reflection !== ""
    tooltipText: root.song
    onPressed: function(mouseButton) {
      if (mouseButton === Qt.LeftButton) root.broadcast("advance")
    }

    Text {
      id: label
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      anchors.leftMargin: Style.space(8)
      width: Math.min(implicitWidth, 400)
      text: root.reflection
      textFormat: Text.PlainText
      elide: Text.ElideRight
      color: root.bar ? root.bar.barForeground : Color.foreground
      opacity: 0.75
      font.family: root.bar ? root.bar.fontFamily : Style.font.family
      font.pixelSize: Style.font.body
      font.italic: true
      renderType: Text.NativeRendering
    }
  }
}
