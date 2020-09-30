import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Item{
    id: root

    required property var question
    required property int index

    property var __shuffledAnswers
    property bool __correctAnswer: false

    signal answeredCorrectly()
    signal answeredWrong()

    implicitWidth: parent.width
    implicitHeight: parent.height

    Rectangle {
        id: dialog

        width: parent.width
        height: parent.height

        Component.onCompleted: {
            checkButton.enabled = false;
            nextQuestionButton.enabled = false;

            root.__shuffledAnswers = makeAnswerArray(question.answer1,
                                                question.answer2,
                                                question.answer3,
                                                question.answer4);
            shuffleArray(root.__shuffledAnswers);

            answer1TextField.text = root.__shuffledAnswers[0];
            answer2TextField.text = root.__shuffledAnswers[1];
            answer3TextField.text = root.__shuffledAnswers[2];
            answer4TextField.text = root.__shuffledAnswers[3];
        }

        ButtonGroup {
            id: radioGroup
        }

        ColumnLayout{
            anchors.fill: parent

            RowLayout{
                Text{
                    text: qsTr("Question: " + question.id)
                }
            }
            RowLayout{
                Text{
                    text: qsTr(question.askedQuestion)
                }
            }
            RowLayout{
                Image{
                    id: image

                    source: question.picture.length > 0 ?
                                "data:image/png;base64," + question.picture: ""
                }
            }
            RowLayout{
                RadioButton{
                    id: radioButtonAnswer1
                    ButtonGroup.group: radioGroup
                    onCheckedChanged: {
                        if(checked) {
                            checkButton.enabled = true
                            if(root.question.correctAnswer === 1) {
                                __correctAnswer = true
                            }
                            else {
                                __correctAnswer = false
                            }
                        }
                    }
                }
                AnswerTextField{
                    Layout.fillWidth: true
                    id: answer1TextField
                }
            }
            RowLayout{
                RadioButton{
                    id: radioButtonAnswer2
                    ButtonGroup.group: radioGroup
                    onCheckedChanged: {
                        if(checked) {
                            checkButton.enabled = true
                            if(root.question.correctAnswer === 2) {
                                __correctAnswer = true
                            }
                            else {
                                __correctAnswer = false
                            }
                        }
                    }
                }
                AnswerTextField{
                    Layout.fillWidth: true
                    id: answer2TextField
                }
            }
            RowLayout{
                RadioButton{
                    id: radioButtonAnswer3
                    ButtonGroup.group: radioGroup
                    onCheckedChanged: {
                        if(checked) {
                            checkButton.enabled = true
                            if(root.question.correctAnswer === 3) {
                                __correctAnswer = true
                            }
                            else {
                                __correctAnswer = false
                            }
                        }
                    }
                }
                AnswerTextField{
                    Layout.fillWidth: true
                    id: answer3TextField
                }
            }
            RowLayout{
                RadioButton{
                    id: radioButtonAnswer4
                    ButtonGroup.group: radioGroup
                    onCheckedChanged: {
                        if(checked) {
                            checkButton.enabled = true
                            if(root.question.correctAnswer === 4) {
                                __correctAnswer = true
                            }
                            else {
                                __correctAnswer = false
                            }
                        }
                    }
                }
                AnswerTextField{
                    Layout.fillWidth: true
                    id: answer4TextField
                }
            }
            RowLayout{
                Layout.alignment: Qt.AlignRight
                Button{
                    id: checkButton
                    text: qsTr("Check Answer")
                    onPressed: {
                        markAnswers(root.question.correctAnswer);
                        disableRadioButtons();
                        enabled = false
                        nextQuestionButton.enabled = true
                    }
                }
                Button{
                    id: nextQuestionButton
                    text: qsTr("Next Question")
                    onPressed: {
                        if(root.__correctAnswer) {
                            root.answeredCorrectly()
                        }
                        else {
                            root.answeredWrong()
                        }
                    }
                }
            }
        }
    }

    function makeAnswerArray(answer1, answer2, answer3, answer4)
    {
        return [answer1, answer2, answer3, answer4];
    }

    function shuffleArray(array)
    {
        for (var i = array.length - 1; i > 0; i--) {
            var j = Math.floor(Math.random() * (i + 1));
            var temp = array[i];
            array[i] = array[j];
            array[j] = temp;
        }
    }

    readonly property string correctAnswerColor: "#99FFCC"
    readonly property string wrongAnswerColor: "#FF9999"

    function markAnswers(correctAnswer)
    {
        switch(correctAnswer)
        {
            case 1:
                markAnswersIfAnswer1IsCorrect();
                break;
            case 2:
                markAnswersIfAnswer1IsCorrect();
                break;
            case 3:
                markAnswersIfAnswer1IsCorrect();
                break;
            case 4:
                markAnswersIfAnswer1IsCorrect();
                break;
            default:
                console.assert(false, "Invalid Value for correctAnswer: "
                                + correctAnswer)

        }
    }

    function markAnswersIfAnswer1IsCorrect()
    {
        answer1TextField.backgroundColor = correctAnswerColor
        answer2TextField.backgroundColor = wrongAnswerColor
        answer3TextField.backgroundColor = wrongAnswerColor
        answer4TextField.backgroundColor = wrongAnswerColor
    }

    function markAnswersIfAnswer2IsCorrect()
    {
        answer1TextField.backgroundColor = wrongAnswerColor
        answer2TextField.backgroundColor = correctAnswerColor
        answer3TextField.backgroundColor = wrongAnswerColor
        answer4TextField.backgroundColor = wrongAnswerColor
    }

    function markAnswersIfAnswer3IsCorrect()
    {
        answer1TextField.backgroundColor = wrongAnswerColor
        answer2TextField.backgroundColor = wrongAnswerColor
        answer3TextField.backgroundColor = correctAnswerColor
        answer4TextField.backgroundColor = wrongAnswerColor
    }

    function markAnswersIfAnswer4IsCorrect()
    {
        answer1TextField.backgroundColor = wrongAnswerColor
        answer2TextField.backgroundColor = wrongAnswerColor
        answer3TextField.backgroundColor = wrongAnswerColor
        answer4TextField.backgroundColor = correctAnswerColor
    }

    function disableRadioButtons()
    {
        radioButtonAnswer1.enabled = false
        radioButtonAnswer2.enabled = false
        radioButtonAnswer3.enabled = false
        radioButtonAnswer4.enabled = false
    }
}
