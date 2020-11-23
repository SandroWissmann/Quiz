import QtQuick 2.15
import QtQuick.Controls 2.15

Frame {
    property alias text: text.text

    implicitHeight: 40

    Label {
        id: text
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
