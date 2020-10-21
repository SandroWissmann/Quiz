import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Qt.labs.qmlmodels 1.0

import "add_new_question_dialog"
import "sql_table_view"

ApplicationWindow {
    id: root
    visible: true
    width: 1700
    height: 800
    title: qsTr("Quiz")

    readonly property int countOfQuestions: 10

    readonly property string __newQuizPath: "qrc:/qml/quiz/Quiz.qml"
    readonly property string __newShowTablePath: "qrc:/qml/sql_table_view/SqlTableView.qml"
    readonly property string __resultPath: "qrc:/qml/result/Result.qml"

    Component.onCompleted: {
        showButtonsIfConditionsAreMet()
    }

    Loader {
        id: loader
        anchors.fill: parent
        onLoaded: {
            if (source == root.__newQuizPath) {
                showTableButton.enabled = false
                addQuestionButton.enabled = false
                newQuizButton.enabled = false
            } else if (source == root.__resultPath) {
                showButtonsIfConditionsAreMet()
                addQuestionButton.enabled = true
            }
        }
    }

    menuBar: ToolBar {
        Flow {
            anchors.fill: parent
            ToolButton {
                id: newQuizButton
                text: qsTr("New Quiz")
                icon.name: "address-book-new"
                onClicked: {
                    randomQuestionFilterModel.generateRandomQuestions(
                                countOfQuestions)
                    loader.setSource(root.__newQuizPath)
                }
            }
            ToolButton {
                id: showTableButton
                text: qsTr("Show Table")
                icon.name: "document-open"
                onClicked: {
                    loader.setSource(root.__newShowTablePath)
                }
            }
            ToolButton {
                id: addQuestionButton
                text: qsTr("Add Question")
                icon.name: "document-new"
                onClicked: addQuestionDialog.open()
            }
        }

        AddNewQuestionDialog {
            id: addQuestionDialog
            onAccepted: showButtonsIfConditionsAreMet()
        }
    }

    Connections {
        id: quizConnections
        target: loader.item
        ignoreUnknownSignals: loader.source !== root.__newQuizPath

        function onFinnished(correctAnswers) {
            loader.setSource(root.__resultPath, {
                                 "correctAnswers": correctAnswers,
                                 "countOfQuestions": countOfQuestions
                             })
        }
    }

    function showButtonsIfConditionsAreMet() {
        showTableButton.enabled = questionsProxyModel.rowCount() !== 0
        newQuizButton.enabled = questionsProxyModel.rowCount(
                    ) >= root.countOfQuestions
    }
}
