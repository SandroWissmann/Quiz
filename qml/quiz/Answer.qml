import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

RowLayout{
    id: root

    required property var buttonGroup
    property bool correct: false

    property bool showResultColor: false

    property alias text: answerTextField.text
    property alias enabled: radioButtonAnswer.enabled

    signal checked

    RadioButton{
        id: radioButtonAnswer
        ButtonGroup.group: buttonGroup
        onCheckedChanged: {
            if(checked) {
                root.checked()
            }
        }
    }
    AnswerTextField{
        Layout.fillWidth: true
        id: answerTextField
        backgroundColor: getAnswerTextBackgroundColor(
                             root.showResultColor, root.isCorrect)

        MouseArea{
            anchors.fill: parent
            width: parent.width
            height: parent.height
            onClicked: {
                radioButtonAnswer.checked = true
            }
        }
    }

    function getAnswerTextBackgroundColor(showResult, isCorrect)
    {
        var correctAnswerColor = "#99FFCC";
        var wrongAnswerColor = "#FF9999";

        if(!showResult) {
            return "white";
        }
        if(correct) {
            return correctAnswerColor;
        }
        return wrongAnswerColor;
    }

}
