pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool checking: false
    property bool updating: false
    property list<Package> updates: []

    reloadableId: "packageManager"

    function recheckPackages(enabled: bool): void {
        checkPackages.exec();
        updateTimer.restart();
    }

    Timer {
        id: updateTimer
        interval: 30 * 60 * 1000 // 30 minutes
        running: true
        repeat: true
        onTriggered: checkPackages.exec()
    }

    Process {
        id: checkPackages
        running: true
        command: ["bash", "-c", "paru -Qu | awk '{print $1, $4}'"]
        onStarted: {
          checking = true
        }
        onExited: {
          console.log('Exited')
          checking = false
        }
        stdout: StdioCollector {
            onStreamFinished: {
              const lines = text.trim().split('\n');

              root.updates = lines.map(line => {
                const v = line.trim().split(' ')

                console.log(v)
                return pComp.createObject(root, {
                  name: v[0],
                  newVersion: v[1]
                })
              })
            }
        }
    }

    component Package: QtObject {
      required property string name
      required property string newVersion
    }

    Component {
        id: pComp

        Package {}
    }
}
