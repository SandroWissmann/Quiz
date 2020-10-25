import QtQuick 2.15

import "../../add_new_question_dialog"

Item {
    property int row

    property string picture

    readonly property string __pictureFileDialogPath: "qrc:/qml/add_new_question_dialog/PictureFileDialog.qml"

    signal valueChanged(int row, string value, string role)

    id: root
    Rectangle {
        id: rect
        anchors.fill: parent
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
        onDoubleClicked: {
            if (loader.source != root.__pictureFileDialogPath) {
                loader.setSource(__pictureFileDialogPath)
            }
            loader.active = false
            loader.active = true
            loader.item.open()
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
}
