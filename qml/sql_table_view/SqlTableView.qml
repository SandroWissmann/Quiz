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
                    width: tableView.columnWidthProvider(column)
                    text: model.id
                }
            }
            DelegateChoice {
                column: 1
                delegate: AskedQuestion {
                    width: tableView.columnWidthProvider(column)
                    text: model.askedQuestion
                    backgroundColor: chooser.askedQuestionColor
                }
            }
            DelegateChoice {
                column: 2
                delegate: Answer1 {
                    width: tableView.columnWidthProvider(column)
                    text: answer1
                    backgroundColor: model.correctAnswer
                                     === 1 ? chooser.correctAnswerColor : chooser.wrongAnswerColor
                }
            }
            DelegateChoice {
                column: 3
                delegate: Answer2 {
                    width: tableView.columnWidthProvider(column)
                    text: model.answer2
                    backgroundColor: model.correctAnswer
                                     === 2 ? chooser.correctAnswerColor : chooser.wrongAnswerColor
                }
            }
            DelegateChoice {
                column: 4
                delegate: Answer3 {
                    width: tableView.columnWidthProvider(column)
                    text: model.answer3
                    backgroundColor: model.correctAnswer
                                     === 3 ? chooser.correctAnswerColor : chooser.wrongAnswerColor
                }
            }
            DelegateChoice {
                column: 5
                delegate: Answer4 {
                    width: tableView.columnWidthProvider(column)
                    text: model.answer4
                    backgroundColor: model.correctAnswer
                                     === 4 ? chooser.correctAnswerColor : chooser.wrongAnswerColor
                }
            }
            DelegateChoice {
                column: 6
                delegate: CorrectAnswer {
                    width: tableView.columnWidthProvider(column)
                    value: model.correctAnswer
                }
            }
            DelegateChoice {
                column: 7
                delegate: Picture {
                    width: tableView.columnWidthProvider(column)
                    picture: model.picture
                }
            }
        }
        ScrollBar.vertical: ScrollBar {}
    }
}
