pragma ComponentBehavior: Bound

import qs.components
import qs.components.controls
import qs.services
import qs.config
import qs.utils
import Quickshell
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    spacing: Appearance.spacing.small
    width: Config.bar.sizes.packageManagerWidth

    RowLayout {
      StyledText {
          Layout.topMargin: Appearance.padding.normal
          Layout.rightMargin: Appearance.padding.small
          Layout.bottomMargin: Appearance.padding.normal
          text: {
            if (PackageManager.checking) {
              return qsTr("Cheking ...")
            }

            if (PackageManager.updates.length > 0) return qsTr("Updates")

            return qsTr("Up to date")
          }
          font.weight: 500
      }

      StyledRect {
          id: connectBtn

          implicitWidth: implicitHeight
          implicitHeight: connectIcon.implicitHeight + Appearance.padding.small
          anchors.right: updateAllBtn.left

          radius: Appearance.rounding.full
          color: Colours.palette.m3primary

          StyledBusyIndicator {
              anchors.fill: parent
              running: PackageManager.checking
          }

          StateLayer {
              color: Colours.palette.m3onSurface
              disabled: PackageManager.checking

              function onClicked(): void {
                console.log('Refresh')
              }
          }

          MaterialIcon {
              id: refreshIcon

              anchors.centerIn: parent
              animate: true
              text: "refresh"
              color: Colours.palette.m3onPrimary

              opacity: PackageManager.checking ? 0 : 1

              Behavior on opacity {
                  Anim {}
              }
          }
      }

      StyledRect {
          id: updateAllBtn

          implicitWidth: implicitHeight
          implicitHeight: connectIcon.implicitHeight + Appearance.padding.small
          anchors.right: parent.right

          radius: Appearance.rounding.full
          color: Colours.palette.m3primary

          StyledBusyIndicator {
              anchors.fill: parent
              running: PackageManager.checking
          }

          StateLayer {
              color: Colours.palette.m3onSurface
              disabled: PackageManager.checking

              function onClicked(): void {
                console.log('Refresh')
              }
          }

          MaterialIcon {
              id: updateAllIcon

              anchors.centerIn: parent
              animate: true
              text: "refresh"
              color: Colours.palette.m3onPrimary

              opacity: PackageManager.checking ? 0 : 1

              Behavior on opacity {
                  Anim {}
              }
          }
      }
    }

    Repeater {
      model: ScriptModel {
        values: [...PackageManager.updates].slice(0, 5)
      }

      RowLayout {
        id: packageItem
        required property PackageManager.Package modelData

        StyledText {
          text: packageItem.modelData.name
        }

        MaterialIcon {
          text: 'arrow_right_alt'
        }

        StyledText {
          text: packageItem.modelData.newVersion
          color: Colours.palette.m3primary
          font.weight: 500
        }
      }
    }

    StyledRect {
        Layout.topMargin: Appearance.spacing.small
        implicitWidth: expandBtn.implicitWidth + Appearance.padding.normal * 2
        implicitHeight: expandBtn.implicitHeight + Appearance.padding.small
        anchors.left: parent.left
        anchors.right: parent.right
        radius: Appearance.rounding.normal
        color: Colours.palette.m3primaryContainer

        StateLayer {
            color: Colours.palette.m3onPrimaryContainer

            function onClicked(): void {
                root.wrapper.detach("bluetooth");
            }
        }

        RowLayout {
            id: expandBtn

            anchors.centerIn: parent
            spacing: Appearance.spacing.small

            StyledText {
                Layout.leftMargin: Appearance.padding.smaller
                text: qsTr(PackageManager.updates.length > 5 ? `... and ${PackageManager.updates.length - 5} more` : "Show all")
                color: Colours.palette.m3onPrimaryContainer
            }

            MaterialIcon {
                text: "chevron_right"
                color: Colours.palette.m3onPrimaryContainer
                font.pointSize: Appearance.font.size.large
            }
        }
    }

    component Toggle: RowLayout {
        required property string label
        property alias checked: toggle.checked
        property alias toggle: toggle

        Layout.fillWidth: true
        Layout.rightMargin: Appearance.padding.small
        spacing: Appearance.spacing.normal

        StyledText {
            Layout.fillWidth: true
            text: parent.label
        }

        StyledSwitch {
            id: toggle
        }
    }

    component Anim: NumberAnimation {
        duration: Appearance.anim.durations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.anim.curves.standard
    }
}
