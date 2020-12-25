
/* Quiz
 * Copyright (C) 2020  Sandro Wißmann
 *
 * Quiz is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Quiz is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Quiz If not, see <http://www.gnu.org/licenses/>.
 *
 * Web-Site: https://github.com/SandroWissmann/Quiz
 */
import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    property int row

    signal markForDelete(int row)

    id: root

    implicitHeight: 100

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    readOnly: true

    background: Frame {}

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.RightButton

        onClicked: {
            eraseContextMenu.popup(root, 0, mouseArea.mouseY + 10)
        }
    }

    Menu {
        id: eraseContextMenu
        y: root.y
        MenuItem {
            text: qsTr("Delete entry")
            onTriggered: {
                eraseDialog.open()
                eraseContextMenu.close()
            }
        }
        MenuItem {
            text: qsTr("Cancel")
            onTriggered: {
                eraseContextMenu.close()
            }
        }
    }

    Dialog {
        id: eraseDialog
        implicitWidth: 400
        title: qsTr("Delete database entry")
        modal: true
        focus: true

        contentItem: Label {
            id: label
            text: qsTr("Do you really want to erase the entry with id %1?").arg(
                      root.text)
        }

        onAccepted: {
            markForDelete(root.row)
        }

        standardButtons: Dialog.Ok | Dialog.Cancel
    }
}
