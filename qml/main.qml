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
import Qt.labs.settings 1.0
import QtQuick.Controls.Material 2.15

import LanguageSelectors 1.0

import "add_new_question_dialog"
import "sql_table_view"
import "settings_dialog"

ApplicationWindow {
    id: root
    visible: true
    width: __defaultWidth
    height: 800
    title: qsTr("Quiz")

    readonly property int __showTableWidth: 1460
    readonly property int __defaultWidth: 880

    property int countOfQuestions
    property bool darkModeOn

    readonly property string __newQuizPath: "qrc:/qml/quiz/Quiz.qml"
    readonly property string __newShowTablePath: "qrc:/qml/sql_table_view/SqlTableView.qml"
    readonly property string __newAddNewQuestionDialog: "qrc:/qml/add_new_question_dialog/AddNewQuestionDialog.qml"
    readonly property string __resultPath: "qrc:/qml/result/Result.qml"
    readonly property string __settingsDialogPath: "qrc:/qml/settings_dialog/SettingsDialog.qml"

    Settings {
        id: settings
        property int language: LanguageSelector.German
        property int countOfQuestions: 10
        property bool darkModeOn: false
    }
    Component.onCompleted: {
        showButtonsIfConditionsAreMet()
        LanguageSelector.language = settings.language
        root.countOfQuestions = settings.countOfQuestions
        root.darkModeOn = settings.darkModeOn
        selectColorMode()
    }

    Component.onDestruction: {
        settings.language = LanguageSelector.language
        settings.countOfQuestions = root.countOfQuestions
        settings.darkModeOn = root.darkModeOn
    }

    Loader {
        id: loader
        anchors.fill: parent
        onLoaded: {
            if (source == root.__newQuizPath) {
                showTableButton.enabled = false
                addQuestionButton.enabled = false
                newQuizButton.enabled = false
                settingsButton.enabled = false
            } else if (source == root.__resultPath) {
                showButtonsIfConditionsAreMet()
                addQuestionButton.enabled = true
                settingsButton.enabled = true
            }
        }
    }

    Loader {
        id: addNewQuestionloader
        anchors.fill: parent
    }

    Loader {
        id: settingsloader
        anchors.fill: parent
    }

    header: ToolBar {
        Flow {
            anchors.fill: parent
            ToolButton {
                id: newQuizButton
                text: qsTr("New Quiz")
                icon.name: "address-book-new"
                onClicked: {
                    root.width = root.__defaultWidth
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
                    root.width = root.__showTableWidth
                    loader.setSource(root.__newShowTablePath)
                }
            }
            ToolButton {
                id: addQuestionButton
                text: qsTr("Add Question")
                icon.name: "document-new"
                onClicked: {
                    addNewQuestionloader.active = false
                    addNewQuestionloader.active = true
                    if (addNewQuestionloader.source !== root.__newAddNewQuestionDialog) {
                        addNewQuestionloader.setSource(
                                    root.__newAddNewQuestionDialog)
                    }
                    addNewQuestionloader.item.open()
                }
            }
            ToolButton {
                id: settingsButton
                text: qsTr("Settings")
                icon.name: "help-about"

                onClicked: {
                    settingsloader.active = false
                    settingsloader.active = true
                    if (settingsloader.source !== root.__settingsDialogPath) {
                        settingsloader.setSource(root.__settingsDialogPath, {
                                                     "countOfQuestions": root.countOfQuestions,
                                                     "darkModeOn": root.darkModeOn
                                                 })
                    }
                    settingsloader.item.open()
                }
            }
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

    Connections {
        id: settingsDialogConnections
        target: settingsloader.item
        ignoreUnknownSignals: loader.source !== root.__settingsDialogPath

        function onCountOfQuestionsChanged() {
            root.countOfQuestions = settingsloader.item.countOfQuestions
        }
        function onDarkModeOnChanged() {
            root.darkModeOn = settingsloader.item.darkModeOn
            selectColorMode()
        }
    }
    Connections {
        id: addNewQuestionDialogConnections
        target: addNewQuestionloader.item
        ignoreUnknownSignals: loader.source !== root.__newAddNewQuestionDialog

        function onAccepted() {
            showButtonsIfConditionsAreMet()
        }
    }

    function showButtonsIfConditionsAreMet() {
        showTableButton.enabled = questionsProxyModel.rowCount() !== 0
        newQuizButton.enabled = questionsProxyModel.rowCount(
                    ) >= root.countOfQuestions
    }

    function selectColorMode() {
        if (root.darkModeOn) {
            Material.theme = Material.Dark
        } else {
            Material.theme = Material.Light
        }
    }
}
