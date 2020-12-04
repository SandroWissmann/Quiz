
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

import "../../../add_new_question_dialog"

Frame {
    property string picture

    property int row

    readonly property string __pictureFileDialogPath: "qrc:/qml/add_new_question_dialog/PictureFileDialog.qml"

    signal valueChanged(int row, string value, string role)

    id: root

    Image {
        id: image

        anchors.fill: parent
        source: root.picture.length > 0 ? "data:image/png;base64," + root.picture : ""
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onDoubleClicked: {
            if (image.source != "") {
                zoomImageDialog.open()
            }
        }
        onClicked: {
            if (mouse.button == Qt.RightButton) {
                editContextMenu.popup()
            }
        }
        onPressAndHold: {
            if (mouse.source === Qt.MouseEventNotSynthesized) {
                editContextMenu.popup()
            }
        }
    }

    Dialog {
        id: zoomImageDialog
        modal: true
        focus: true

        anchors.centerIn: Overlay.overlay

        standardButtons: Dialog.Close

        Image {
            id: zoomImage
            anchors.centerIn: parent
            source: root.picture.length > 0 ? "data:image/png;base64," + root.picture : ""
            fillMode: Image.PreserveAspectFit
            sourceSize.width: 300
            sourceSize.height: 300
        }

        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    }

    Menu {
        id: editContextMenu
        y: root.y
        MenuItem {
            text: picture == "" ? qsTr("Add") : qsTr("Replace")
            onTriggered: {
                openNewFileDialog()
            }
        }
        MenuItem {
            text: qsTr("Delete")
            onTriggered: {
                valueChanged(row, "", "picture")
            }
        }
    }

    Loader {
        id: loader
    }

    Connections {
        id: pictureFileDialogConnnections
        target: loader.item
        ignoreUnknownSignals: loader.source !== root.__pictureFileDialogPath

        function onAccepted() {
            var pictureUrl = String(loader.item.fileUrl)
            pictureUrl = pictureUrl.replace("file://", "")

            valueChanged(row, pictureUrl, "picture")
        }
    }

    function openNewFileDialog() {
        if (loader.source != root.__pictureFileDialogPath) {
            loader.setSource(__pictureFileDialogPath)
        }
        loader.active = false
        loader.active = true
        loader.item.open()
    }
}
