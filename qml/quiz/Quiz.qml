import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: quiz

    required property var randomQuestions

    width: parent.width
    height: parent.height

    SwipeView{
        id: quizSwipeView
        interactive: false
        anchors.fill: parent
    }

    Component.onCompleted: {
        var quizPage;
        for(var i=0; i<randomQuestions.length; ++i) {
            quizPage = createQuizPage(quizSwipeView, randomQuestions[i]);
            quizSwipeView.addItem(quizPage);
        }
        quizSwipeView.setCurrentIndex(0)
        console.log(quizSwipeView.count)
        console.log(quizSwipeView.currentItem.width)
        console.log(quizSwipeView.currentItem.height)
    }

    function createQuizPage(parent, randomQuestion) {
        var component = Qt.createComponent("QuizPage.qml");
        var object = component.createObject(parent, {question: randomQuestion});

        if (object === null) {
            console.log("Error creating quizPage");
        }
        return object
    }
}
