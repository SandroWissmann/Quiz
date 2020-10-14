import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Item {
    id: root

    property int questionId
    property string askedQuestion
    property string answer1
    property string answer2
    property string answer3
    property string answer4
    property int correctAnswer
    property string picture

    property bool lastQuestion: false

    property bool __correctAnswer: false

    signal answeredCorrectly
    signal answeredWrong

    implicitWidth: parent.width
    implicitHeight: parent.height

    Rectangle {
        id: dialog

        width: parent.width
        height: parent.height

        Component.onCompleted: {
            populateAnswersRandom()
        }

        ButtonGroup {
            id: radioGroup
        }

        ColumnLayout {
            anchors.fill: parent

            RowLayout {
                Text {
                    text: qsTr("Question: %1").arg(root.questionId)
                }
            }
            RowLayout {
                Text {
                    text: qsTr(root.askedQuestion)
                }
            }
            RowLayout {
                Image {
                    id: image

                    source: root.picture.length > 0 ? "data:image/png;base64," + root.picture : ""
                    sourceSize.width: 1024
                    sourceSize.height: 1024
                }
            }
            Repeater {
                id: answerRepeater
                model: 4
                Answer {
                    buttonGroup: radioGroup
                    onChecked: {
                        checkButton.enabled = true
                        if (correct) {
                            root.__correctAnswer = true
                        }
                    }
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignRight
                Button {
                    id: checkButton
                    text: qsTr("Check Answer")
                    enabled: false
                    onPressed: {
                        for (var i = 0; i < answerRepeater.count; ++i) {
                            answerRepeater.itemAt(i).showResultColor = true
                            answerRepeater.itemAt(i).enabled = false
                        }

                        enabled = false
                        nextQuestionButton.enabled = true
                    }
                }
                Button {
                    id: nextQuestionButton
                    text: {
                        if (lastQuestion) {
                            return qsTr("Show Result")
                        }
                        return qsTr("Next Question")
                    }
                    enabled: false
                    onPressed: {
                        if (root.__correctAnswer) {
                            root.answeredCorrectly()
                        } else {
                            root.answeredWrong()
                        }
                    }
                }
            }
        }
    }

    function populateAnswersRandom() {
        var correctAnwer = root.correctAnswer
        var shuffledAnswers = makeAnswerArray(root.answer1, root.answer2,
                                              root.answer3, root.answer4)
        var correctAnswerText = shuffledAnswers[correctAnwer - 1]
        shuffleArray(shuffledAnswers)

        for (var i = 0; i < shuffledAnswers.length; ++i) {
            if (shuffledAnswers[i] === correctAnswerText) {
                correctAnwer = i + 1
                break
            }
        }
        answerRepeater.itemAt(correctAnwer - 1).correct = true

        for (i = 0; i < answerRepeater.count; ++i) {
            answerRepeater.itemAt(i).text = shuffledAnswers[i]
        }
    }

    function makeAnswerArray(answer1, answer2, answer3, answer4) {
        return [answer1, answer2, answer3, answer4]
    }

    function shuffleArray(array) {
        for (var i = array.length - 1; i > 0; i--) {
            var j = Math.floor(Math.random() * (i + 1))
            var temp = array[i]
            array[i] = array[j]
            array[j] = temp
        }
    }
}
