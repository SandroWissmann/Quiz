import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: quiz

    required property var randomQuestions

    property int correctAnswers: 0

    signal allAnswersAnswered(int correctAnswers)

    width: parent.width
    height: parent.height

    SwipeView{
        id: quizSwipeView
        interactive: false
        anchors.fill: parent

        Repeater{
            model: randomQuestions
            delegate: QuizPage{
                question: randomQuestions[index]
                onAnsweredCorrectly: answeredCorrectly()
                onAnsweredWrong: answeredWrong()
            }
        }
    }

    function answeredCorrectly() {
        ++quiz.correctAnswers
        quizSwipeView.incrementCurrentIndex()
    }

    function answeredWrong() {
        quizSwipeView.incrementCurrentIndex()
    }
}
