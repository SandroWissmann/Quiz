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
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

RowLayout {
    id: root

    property var buttonGroup
    property bool correct: false

    property bool showResultColor: false

    property alias text: answerTextField.text
    property alias enabled: radioButtonAnswer.enabled

    signal checked

    RadioButton {
        id: radioButtonAnswer
        ButtonGroup.group: buttonGroup
        onCheckedChanged: {
            if (checked) {
                root.checked()
            }
        }
    }
    TextField {
        Layout.fillWidth: true
        id: answerTextField
        readOnly: true
        selectByMouse: false
        padding: 8

        background: Frame {}

        MouseArea {
            anchors.fill: parent
            width: parent.width
            height: parent.height
            onClicked: {
                radioButtonAnswer.checked = true
            }
        }
    }

    onShowResultColorChanged: {
        if (showResultColor) {
            answerTextField.color = getAnswerTextBackgroundColor(root.correct)
        }
    }

    function getAnswerTextBackgroundColor(isCorrect) {
        if (isCorrect) {
            return Material.color(Material.Green)
        }
        return Material.color(Material.Red)
    }
}
