import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Dialog {
    id: dialog
    x: 100
    y: 100
    width: 500
    height: 600
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    title: qsTr("Settings")

    onOpened: {
        standardButton(Dialog.Close).text = qsTr("Close")
    }

    ColumnLayout {
        RadioButton {
            text: qsTr("German")
            onPressed: languageSelector.changeLanguage(LanguageSelector.german)
        }
        RadioButton {
            checked: true
            text: qsTr("English")
            onPressed: languageSelector.changeLanguage(LanguageSelector.english)
        }
        RadioButton {
            text: qsTr("Spanish")
            onPressed: languageSelector.changeLanguage(2)
        }
    }

    standardButtons: Dialog.Close
}
