import QtQuick 2.15
import QtQuick.Controls 2.15

TextArea {
    property alias backgroundColor: backgroundRect.color

    id: displayText
    wrapMode: TextArea.WordWrap
    selectByMouse: true

    implicitHeight: 100
    background: Rectangle {
        id: backgroundRect
        border.color: "black"
    }
}
