import QtQuick 2.15
import QtQuick.Controls 2.15

Dialog {
    property alias text: label.text
    x: 100
    y: 100
    width: 300
    height: 200
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    contentItem: Label {
        id: label
        wrapMode: TextArea.WordWrap
    }
    standardButtons: Dialog.Close

    onTextChanged: {
        console.log(text)
    }
}
