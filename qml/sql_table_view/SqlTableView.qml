import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Qt.labs.qmlmodels 1.0

import "data"

Item {
    id: root
    HorizontalHeaderView {
        id: horizontalHeaderView
        syncView: tableView
        anchors.left: tableView.left
        model: [qsTr("Id"), qsTr("Question"), qsTr("Answer 1"), qsTr(
                "Answer 2"), qsTr("Answer 3"), qsTr("Answer 4"), qsTr(
                "Correct Answer"), qsTr("Picture")]
    }
    TableView {
        id: tableView
        width: parent.width
        height: parent.height - horizontalHeaderView.height
        anchors.top: horizontalHeaderView.bottom
        boundsBehavior: Flickable.StopAtBounds

        reuseItems: true
        clip: true
        property var columnWidths: [60, 220, 220, 220, 220, 220, 100, 140]
        columnWidthProvider: function (column) {
            return columnWidths[column]
        }

        model: questionsProxyModel

        delegate: DelegateChooser {
            id: chooser

            readonly property string askedQuestionColor: "#99CCFF"
            readonly property string correctAnswerColor: "#99FFCC"
            readonly property string wrongAnswerColor: "#FF9999"

            DelegateChoice {
                column: 0
                delegate: QuestionId {
                    id: questionIdDelegate
                    width: tableView.columnWidthProvider(column)
                    text: model.id
                }
            }
            DelegateChoice {
                column: 1
                delegate: AskedQuestion {
                    id: askedQuestionDelegate
                    width: tableView.columnWidthProvider(column)
                    text: model.askedQuestion
                    backgroundColor: chooser.askedQuestionColor
                    row: model.row

                    Component.onCompleted: {
                        askedQuestionDelegate.valueChanged.connect(
                                    tableView.saveToDatabase)
                    }
                }
            }
            DelegateChoice {
                column: 2
                delegate: Answer1 {
                    id: answer1Delegate
                    width: tableView.columnWidthProvider(column)
                    text: answer1
                    backgroundColor: model.correctAnswer
                                     === 1 ? chooser.correctAnswerColor : chooser.wrongAnswerColor
                    row: model.row

                    Component.onCompleted: {
                        answer1Delegate.valueChanged.connect(
                                    tableView.saveToDatabase)
                    }
                }
            }
            DelegateChoice {
                column: 3
                delegate: Answer2 {
                    id: answer2Delegate
                    width: tableView.columnWidthProvider(column)
                    text: model.answer2
                    backgroundColor: model.correctAnswer
                                     === 2 ? chooser.correctAnswerColor : chooser.wrongAnswerColor
                    row: model.row

                    Component.onCompleted: {
                        answer2Delegate.valueChanged.connect(
                                    tableView.saveToDatabase)
                    }
                }
            }
            DelegateChoice {
                column: 4
                delegate: Answer3 {
                    id: answer3Delegate
                    width: tableView.columnWidthProvider(column)
                    text: model.answer3
                    backgroundColor: model.correctAnswer
                                     === 3 ? chooser.correctAnswerColor : chooser.wrongAnswerColor
                    row: model.row

                    Component.onCompleted: {
                        answer3Delegate.valueChanged.connect(
                                    tableView.saveToDatabase)
                    }
                }
            }
            DelegateChoice {
                column: 5
                delegate: Answer4 {
                    id: answer4Delegate
                    width: tableView.columnWidthProvider(column)
                    text: model.answer4
                    backgroundColor: model.correctAnswer
                                     === 4 ? chooser.correctAnswerColor : chooser.wrongAnswerColor
                    row: model.row

                    Component.onCompleted: {
                        answer4Delegate.valueChanged.connect(
                                    tableView.saveToDatabase)
                    }
                }
            }
            DelegateChoice {
                column: 6
                delegate: CorrectAnswer {
                    id: correctAnswerDelegate
                    width: tableView.columnWidthProvider(column)
                    value: model.correctAnswer
                    row: model.row

                    Component.onCompleted: {
                        correctAnswerDelegate.valueChanged.connect(
                                    tableView.saveToDatabase)
                    }
                }
            }
            DelegateChoice {
                column: 7
                delegate: Picture {
                    id: pictureDelegate
                    width: tableView.columnWidthProvider(column)
                    picture: model.picture
                    row: model.row

                    Component.onCompleted: {
                        pictureDelegate.valueChanged.connect(
                                    tableView.saveToDatabase)
                    }
                }
            }
        }
        ScrollBar.vertical: ScrollBar {}

        function saveToDatabase(row, value, role) {
            tableView.model.edit(row, value, role)
        }
    }
}
