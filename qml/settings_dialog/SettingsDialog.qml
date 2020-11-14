import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import LanguageSelectors 1.0

Dialog {
    id: root
    x: 100
    y: 100
    width: 300
    height: 600
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    title: qsTr("Settings")

    property alias countOfQuestions: countOfQuestionsSpinBox.value

    ColumnLayout {
        id: columnLayout
        RowLayout {
            Text {
                text: qsTr("Count of Questions:")
                font.pointSize: 13.5
            }
            SpinBox {
                Layout.fillWidth: true
                id: countOfQuestionsSpinBox
                from: 0
                to: 999
                editable: true
            }
        }
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
