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

Pane {
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

    Component.onCompleted: {
        populateAnswersRandom()
    }

    ButtonGroup {
        id: radioGroup
    }

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: qsTr("Question: %1").arg(root.questionId)
            font.pointSize: 13.5
        }
        TextArea {
            Layout.fillWidth: true
            readOnly: true
            wrapMode: TextEdit.WordWrap
            background: null
            text: qsTr(root.askedQuestion)
            font.pointSize: 13.5
        }
        Image {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter
            fillMode: Image.PreserveAspectFit

            source: root.picture.length > 0 ? "data:image/png;base64," + root.picture : ""
            sourceSize.width: 1024
            sourceSize.height: 1024
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
