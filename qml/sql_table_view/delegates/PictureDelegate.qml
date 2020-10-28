import QtQuick 2.15
import QtQuick.Controls 2.15

import "../../add_new_question_dialog"

Item {
    property string picture

    property int row

    readonly property string __pictureFileDialogPath: "qrc:/qml/add_new_question_dialog/PictureFileDialog.qml"

    signal valueChanged(int row, string value, string role)

    id: root
    Rectangle {
        id: rect
        anchors.fill: parent
        border.width: 1
        border.color: "black"
    }

    Image {
        id: image
        anchors.centerIn: parent
        source: root.picture.length > 0 ? "data:image/png;base64," + root.picture : ""
        fillMode: Image.PreserveAspectFit
        sourceSize.width: rect.width - rect.border.width * 2
        sourceSize.height: rect.height - rect.border.height * 2
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
