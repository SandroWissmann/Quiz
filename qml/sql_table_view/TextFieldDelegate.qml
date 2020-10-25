import QtQuick 2.15
import QtQuick.Controls 2.15

TextArea {
    property int row
    property string role

    property alias backgroundColor: backgroundRect.color

    property bool textModified: false

    signal valueChanged(int row, string value, string role)

    id: displayText
    wrapMode: TextArea.WordWrap
    selectByMouse: true

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

                        if (textModified) {
                            valueChanged(row, text, role)
                        }

                        textModified = false
                    }

    onTextChanged: {
        if (focus) {
            textModified = true
        }
    }
}
