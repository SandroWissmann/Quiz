import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Item{
    id: root

    required property var question

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
            var correctAnwer = root.question.correctAnswer

            var shuffledAnswers = makeAnswerArray(root.question.answer1,
                                                root.question.answer2,
                                                root.question.answer3,
                                                root.question.answer4);
            var correctAnswerText =
                    shuffledAnswers[correctAnwer - 1];
            shuffleArray(shuffledAnswers);

            for(var i=0; i<shuffledAnswers.length; ++i) {
                if(shuffledAnswers[i] === correctAnswerText) {
                    correctAnwer = i + 1;
                    break;
                }
            }

            switch(correctAnwer){
            case 1:
                answer1.isCorrect = true
                break
            case 2:
                answer2.isCorrect = true
                break
            case 3:
                answer3.isCorrect = true
                break
            case 4:
                answer4.isCorrect = true
                break
            default:
                console.log(qsTr("correctAnwer: %1 out of Range")
                            .arg(correctAnwer));
            }


            answer1.text = shuffledAnswers[0];
            answer2.text = shuffledAnswers[1];
            answer3.text = shuffledAnswers[2];
            answer4.text = shuffledAnswers[3];
        }

        ButtonGroup {
            id: radioGroup
        }

        ColumnLayout{
            anchors.fill: parent

            RowLayout{
                Text{
                    text: qsTr("Question: " + root.question.id)
                }
            }
            RowLayout{
                Text{
                    text: qsTr(root.question.askedQuestion)
                }
            }
            RowLayout{
                Image{
                    id: image

                    source: root.question.picture.length > 0 ?
                                "data:image/png;base64,"
                                + root.question.picture: ""
                }
            }
            Answer{
                id: answer1
                buttonGroup: radioGroup
                onChecked: checkButton.enabled = true
            }
            Answer{
                id: answer2
                buttonGroup: radioGroup
                onChecked: checkButton.enabled = true
            }
            Answer{
                id: answer3
                buttonGroup: radioGroup
                onChecked: checkButton.enabled = true
            }
            Answer{
                id: answer4
                buttonGroup: radioGroup
                onChecked: checkButton.enabled = true
            }
            RowLayout{
                Layout.alignment: Qt.AlignRight
                Button{
                    id: checkButton
                    text: qsTr("Check Answer")
                    enabled: false
                    onPressed: {
                        answer1.showResultColor = true
                        answer2.showResultColor = true
                        answer3.showResultColor = true
                        answer4.showResultColor = true

                        answer1.enabled = false
                        answer2.enabled = false
                        answer3.enabled = false
                        answer4.enabled = false

                        enabled = false
                        nextQuestionButton.enabled = true
                    }
                }
                Button{
                    id: nextQuestionButton
                    text: qsTr("Next Question")
                    enabled: false
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
}
