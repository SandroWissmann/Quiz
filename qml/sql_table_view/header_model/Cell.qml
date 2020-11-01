import QtQuick 2.15

Rectangle {
    property alias text: text.text

    color: "#FFFF99"
    border.color: "black"
    border.width: 1

    implicitHeight: 40

    Text {
        id: text
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.pointSize: 13.5
    }
}
