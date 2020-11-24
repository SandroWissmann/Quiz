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

Page {
    id: quiz

    property int correctAnswers: 0

    signal finnished(int correctAnswers)

    width: parent.width
    height: parent.height

    Component.onCompleted: {
        quizPageRepeater.itemAt(quizPageRepeater.count - 1).lastQuestion = true
    }

    SwipeView {
        id: quizSwipeView
        interactive: false
        anchors.fill: parent

        Repeater {
            id: quizPageRepeater
            model: randomQuestionFilterModel
            delegate: QuizPage {
                questionId: model.id
                askedQuestion: model.askedQuestion
                answer1: model.answer1
                answer2: model.answer2
                answer3: model.answer3
                answer4: model.answer4
                correctAnswer: model.correctAnswer
                picture: model.picture
                onAnsweredCorrectly: quiz.answeredCorrectly()
                onAnsweredWrong: quiz.answeredWrong()
            }
        }
    }

    footer: ColumnLayout {
        Label {
            id: footerTextArea
            text: qsTr("Question %1 / %2").arg(
                      quizSwipeView.currentIndex + 1).arg(quizSwipeView.count)
            Layout.alignment: Qt.AlignRight
        }
    }

    function answeredCorrectly() {
        ++quiz.correctAnswers
        loadNextQuestionOrEmitFinnished()
    }

    function answeredWrong() {
        loadNextQuestionOrEmitFinnished()
    }

    function loadNextQuestionOrEmitFinnished() {
        if (quizSwipeView.currentIndex < quizSwipeView.count - 1) {
            quizSwipeView.incrementCurrentIndex()
        } else {
            finnished(correctAnswers)
        }
    }
}
