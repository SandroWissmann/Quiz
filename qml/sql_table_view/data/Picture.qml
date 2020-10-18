import QtQuick 2.15

Item {
    id: root
    property string picture

    Rectangle {
        id: rect
        anchors.fill: parent
        border.color: "black"
    }

    Image {
        anchors.centerIn: parent
        source: root.picture.length > 0 ? "data:image/png;base64," + root.picture : ""
        fillMode: Image.PreserveAspectFit
        sourceSize.width: rect.width - rect.border.width * 2
        sourceSize.height: rect.height - rect.border.height * 2
    }
}
