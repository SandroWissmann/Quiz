
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
import QtQuick.Window 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Controls.Material 2.15

import QuestionsProxyModels 1.0

import "delegates"
import "header_model"

Item {
    signal deleteRow(int row)
    signal valueChanged(int row, var value, string role)

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
        property var columnWidths: [60, 210, 210, 210, 210, 210, 210, 140]
        columnWidthProvider: function (column) {
            return columnWidths[column]
        }

        model: QuestionsProxyModel

        delegate: DelegateChooser {
            id: chooser

            readonly property color askedQuestionColor: Material.color(
                                                            Material.LightBlue)
            readonly property color correctAnswerColor: Material.color(
                                                            Material.Pink)
            readonly property color wrongAnswerColor: Material.color(
                                                          Material.LightGreen)

            DelegateChoice {
                column: 0
                delegate: QuestionIdDelegate {
                    id: questionIdDelegate
                    width: tableView.columnWidthProvider(column)
                    text: model.idx === undefined ? "" : model.idx
                    row: model.row

                    Component.onCompleted: {
                        questionIdDelegate.markForDelete.connect(root.deleteRow)
                    }
                }
            }
            DelegateChoice {
                column: 1
                delegate: AskedQuestionDelegate {
                    id: askedQuestionDelegate
                    width: tableView.columnWidthProvider(column)
                    text: model.askedQuestion === undefined ? "" : model.askedQuestion
                    color: chooser.askedQuestionColor
                    row: model.row

                    Component.onCompleted: {
                        askedQuestionDelegate.valueChanged.connect(
                                    root.valueChanged)
                    }
                }
            }
            DelegateChoice {
                column: 2
                delegate: Answer1Delegate {
                    id: answer1Delegate
                    width: tableView.columnWidthProvider(column)
                    text: model.answer1 === undefined ? "" : model.answer1
                    color: model.correctAnswer
                           === 1 ? chooser.correctAnswerColor : chooser.wrongAnswerColor
                    row: model.row

                    Component.onCompleted: {
                        answer1Delegate.valueChanged.connect(
                                    root.valueChanged)
                    }
                }
            }
            DelegateChoice {
                column: 3
                delegate: Answer2Delegate {
                    id: answer2Delegate
                    width: tableView.columnWidthProvider(column)
                    text: model.answer2 === undefined ? "" : model.answer2
                    color: model.correctAnswer
                           === 2 ? chooser.correctAnswerColor : chooser.wrongAnswerColor
                    row: model.row

                    Component.onCompleted: {
                        answer2Delegate.valueChanged.connect(
                                    root.valueChanged)
                    }
                }
            }
            DelegateChoice {
                column: 4
                delegate: Answer3Delegate {
                    id: answer3Delegate
                    width: tableView.columnWidthProvider(column)
                    text: model.answer3 === undefined ? "" : model.answer3
                    color: model.correctAnswer
                           === 3 ? chooser.correctAnswerColor : chooser.wrongAnswerColor
                    row: model.row

                    Component.onCompleted: {
                        answer3Delegate.valueChanged.connect(
                                    root.valueChanged)
                    }
                }
            }
            DelegateChoice {
                column: 5
                delegate: Answer4Delegate {
                    id: answer4Delegate
                    width: tableView.columnWidthProvider(column)
                    text: model.answer4 === undefined ? "" : model.answer4
                    color: model.correctAnswer
                           === 4 ? chooser.correctAnswerColor : chooser.wrongAnswerColor
                    row: model.row

                    Component.onCompleted: {
                        answer4Delegate.valueChanged.connect(
                                    root.valueChanged)
                    }
                }
            }
            DelegateChoice {
                column: 6
                delegate: CorrectAnswerDelegate {
                    id: correctAnswerDelegate
                    width: tableView.columnWidthProvider(column)
                    value: model.correctAnswer === undefined ? 1 : model.correctAnswer
                    row: model.row

                    Component.onCompleted: {
                        correctAnswerDelegate.correctAnswerChanged.connect(
                                    root.valueChanged)
                    }
                }
            }
            DelegateChoice {
                column: 7
                delegate: PictureDelegate {
                    id: pictureDelegate
                    width: tableView.columnWidthProvider(column)
                    picture: model.picture === undefined ? "" : model.picture
                    row: model.row

                    Component.onCompleted: {
                        pictureDelegate.valueChanged.connect(
                                    root.valueChanged)
                    }
                }
            }
        }
        ScrollBar.vertical: ScrollBar {}
    }
}
