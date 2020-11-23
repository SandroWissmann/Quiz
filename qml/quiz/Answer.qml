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
