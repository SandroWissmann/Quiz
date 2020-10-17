import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: rect
    implicitHeight: 50
    border.width: 1

    property alias text: displayText.text

    TextArea {
        id: displayText

        implicitWidth: rect.implicitWidth
        implicitHeight: rect.implicitHeight
        wrapMode: TextArea.WordWrap
    }
}
