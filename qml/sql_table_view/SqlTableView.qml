import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Qt.labs.qmlmodels 1.0

import "delegates"
import "header_model"

Item {
    id: root
    HorizontalHeaderView {
        id: horizontalHeaderView
        syncView: tableView
        anchors.left: tableView.left

        model: HeaderModel {}
    }
    TableView {
        id: tableView
        width: parent.width
        height: parent.height - horizontalHeaderView.height
        anchors.top: horizontalHeaderView.bottom
        boundsBehavior: Flickable.StopAtBounds

        reuseItems: true
        clip: true
        property var columnWidths: [60, 210, 210, 210, 210, 210, 120, 140]
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
                delegate: QuestionIdDelegate {
                    id: questionIdDelegate
                    width: tableView.columnWidthProvider(column)
                    text: model.id
                }
            }
            DelegateChoice {
                column: 1
                delegate: AskedQuestionDelegate {
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
                delegate: Answer1Delegate {
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
                delegate: Answer2Delegate {
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
                delegate: Answer3Delegate {
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
                delegate: Answer4Delegate {
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
                delegate: CorrectAnswerDelegate {
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
                delegate: PictureDelegate {
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
            console.log(row)
            console.log(value)
            console.log(role)
            tableView.model.edit(row, value, role)
        }
    }
}
