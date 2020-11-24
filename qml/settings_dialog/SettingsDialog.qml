/* Quiz
 * Copyright (C) 2020  Sandro Wißmann
 *
 * Quiz is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Quiz is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Quiz If not, see <http://www.gnu.org/licenses/>.
 *
 * Web-Site: https://github.com/SandroWissmann/Quiz
 */
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import LanguageSelectors 1.0

Dialog {
    id: root
    x: 100
    y: 100
    width: 400
    height: 600
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    title: qsTr("Settings")

    property alias countOfQuestions: countOfQuestionsSpinBox.value

    property bool darkModeOn

    ColumnLayout {
        id: columnLayout
        RowLayout {
            Label {
                text: qsTr("Light")
                font.pointSize: 13.5
            }
            Switch {
                id: colorModeSwitch
                position: darkModeOn ? 1.0 : 0.0

                onPositionChanged: {
                    if (position === 0.0) {
                        root.darkModeOn = false
                    } else {
                        root.darkModeOn = true
                    }
                }
            }
            Label {
                text: qsTr("Dark")
                font.pointSize: 13.5
            }
        }
        RowLayout {
            Label {
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
