import QtQuick 2.15
import QtQuick.Controls 2.15

Frame {
    property int row
    property string role

    property alias color: textArea.color
    property alias text: textArea.text

    property bool textModified: false

    signal valueChanged(int row, string value, string role)

    TextArea {
        anchors.fill: parent
        id: textArea
        Keys.onTabPressed: nextItemInFocusChain().forceActiveFocus(
                               Qt.TabFocusReason)

        wrapMode: TextArea.WordWrap
        selectByMouse: true
        padding: 8
    }

    onFocusChanged: {
        if (!focus && textModified) {
            valueChanged(row, textArea.text, role)
            textModified = false
        }
    }
    onTextChanged: {
        if (focus) {
            textModified = true
        }
    }
}
