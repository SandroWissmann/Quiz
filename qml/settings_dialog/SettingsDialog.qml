import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import LanguageSelectors 1.0

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
            checked: LanguageSelector.language === LanguageSelector.German
            text: qsTr("German")
            onPressed: {
                LanguageSelector.language = LanguageSelector.German
            }
        }
        RadioButton {
            checked: LanguageSelector.language === LanguageSelector.English
            text: qsTr("English")
            onPressed: {
                LanguageSelector.language = LanguageSelector.English
            }
        }
        RadioButton {
            checked: LanguageSelector.language === LanguageSelector.Spanish
            text: qsTr("Spanish")
            onPressed: {
                LanguageSelector.language = LanguageSelector.Spanish
            }
        }
    }

    standardButtons: Dialog.Close
}
