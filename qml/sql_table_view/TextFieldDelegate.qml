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
        color: backgroundColor
        border.width: 1
        border.color: "black"
    }

    onFocusChanged: if (focus) {
                        backgroundRect.border.color = "blue"
                        backgroundRect.border.width = 2
                    } else {
                        backgroundRect.border.color = "black"
                        backgroundRect.border.width = 1
                    }
}
