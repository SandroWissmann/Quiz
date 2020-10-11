import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    property color backgroundColor: "white"
    readOnly: true
    selectByMouse: false

    background: Rectangle {
        color: parent.backgroundColor
        border.color: "gray"
        border.width: 2
    }
}
