import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: quiz

    required property var randomQuestions

    property int correctAnswers: 0

    signal finnished(int correctAnswers)

    width: parent.width
    height: parent.height

    Component.onCompleted: {
        quizPageRepeater.itemAt(quizPageRepeater.count-1).lastQuestion = true
    }

    SwipeView{
        id: quizSwipeView
        interactive: false
        anchors.fill: parent

        Repeater{
            id: quizPageRepeater
            model: randomQuestions
            delegate: QuizPage{
                required property var modelData
                question: modelData
                onAnsweredCorrectly: quiz.answeredCorrectly()
                onAnsweredWrong: quiz.answeredWrong()
            }
        }
    }

    footer:
        ColumnLayout{
            Text{
            id: footerTextArea
            text: "Question " + (quizSwipeView.currentIndex + 1) + " / "
                  + quizSwipeView.count
            Layout.alignment: Qt.AlignRight
        }
    }

    function answeredCorrectly() {
        ++quiz.correctAnswers
        loadNextQuestionOrEmitFinnished();
    }

    function answeredWrong() {
        loadNextQuestionOrEmitFinnished();
    }

    function loadNextQuestionOrEmitFinnished()
    {
        if(quizSwipeView.currentIndex < quizSwipeView.count - 1) {
            quizSwipeView.incrementCurrentIndex();
        }
        else{
            finnished(correctAnswers);
        }
    }
}
