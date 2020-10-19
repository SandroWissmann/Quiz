import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    implicitHeight: 100

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    readOnly: true

    background: Rectangle {
        border.width: 1
        border.color: "black"
    }
}
