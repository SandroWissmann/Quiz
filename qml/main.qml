
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

import QtQuick.Dialogs 1.2

import DatabaseManagers 1.0
import LanguageSelectors 1.0
import QuestionsProxyModels 1.0
import RandomQuestionFilterModels 1.0

import "info_dialog"
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
    property url currentDatabasePath

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
        property url currentDatabasePath: ""
    }

    Component.onCompleted: {
        loadSettings()
        selectColorMode()
        loadDatabaseFromPath()
        reevaluateNewQuizButtonEnabled()
    }

    function loadDatabaseFromPath() {
        if (currentDatabasePath != "") {
            if (!DatabaseManager.changeDatabaseConnection(
                        root.currentDatabasePath)) {
                currentDatabasePath = ""
                databaseErrorInfoDialog.text = DatabaseManager.lastError()
                databaseErrorInfoDialog.open()
                databaseErrorPopup.open()
            }
        }
    }

    InfoDialog {
        id: databaseErrorInfoDialog
        title: qsTr("Database loading error")
    }

    Component.onDestruction: {
        saveSettings()
    }

    Loader {
        id: contentLoader
        anchors.fill: parent
        onLoaded: {
            reevaluateNewQuizButtonEnabled()
            reevaluateDatabaseButtonEnabled()
            reevaluateAddQuestionButtonEnabled()
            reevaluateSettingsButtonEnabled()
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
                    RandomQuestionFilterModel.generateRandomQuestions(
                                countOfQuestions)
                    contentLoader.setSource(root.__newQuizPath)
                }
            }
            ToolButton {
                id: databaseButton
                text: qsTr("Database")
                icon.name: "document-open"

                onClicked: {
                    databaseMenu.popup()
                }

                Menu {
                    id: databaseMenu
                    MenuItem {
                        text: qsTr("Show current")
                        enabled: root.currentDatabasePath != ""

                        onClicked: {
                            root.width = root.__showTableWidth
                            contentLoader.setSource(root.__newShowTablePath)
                        }
                    }
                    MenuItem {
                        text: qsTr("Close current")
                        enabled: root.currentDatabasePath != ""

                        onClicked: {
                            root.width = root.__defaultWidth
                            contentLoader.setSource("")
                            root.currentDatabasePath = ""
                        }
                    }
                    MenuItem {
                        text: qsTr("Open existing")
                        enabled: root.currentDatabasePath == ""

                        onClicked: {
                            selectDatabaseFileDialog.open()
                        }

                        FileDialog {
                            id: selectDatabaseFileDialog
                            title: qsTr("Please choose an existing database")
                            folder: shortcuts.home
                            nameFilters: [qsTr("Database (*.db)")]
                            selectExisting: true
                            selectMultiple: false
                            selectFolder: false

                            onAccepted: {
                                root.currentDatabasePath = selectDatabaseFileDialog.fileUrl
                                loadDatabaseFromPath()
                            }
                        }
                    }
                    MenuItem {
                        text: qsTr("Create new")
                        enabled: root.currentDatabasePath == ""

                        onClicked: {
                            newDatabaseFileDialog.open()
                        }

                        FileDialog {
                            id: newDatabaseFileDialog
                            title: qsTr("Please create a new database")
                            folder: shortcuts.home
                            nameFilters: [qsTr("Database (*.db)")]
                            selectExisting: false
                            selectMultiple: false
                            selectFolder: false

                            onAccepted: {
                                root.currentDatabasePath = newDatabaseFileDialog.fileUrl
                                loadDatabaseFromPath()
                            }
                        }
                    }
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

    footer: Label {
        id: openDatabaseLabel
        text: getOpenDatabaseLabelText()
    }

    onCurrentDatabasePathChanged: {
        openDatabaseLabel.text = getOpenDatabaseLabelText()
    }

    function getOpenDatabaseLabelText() {
        return qsTr("Database: %1").arg(currentDatabasePath)
    }

    Connections {
        id: quizConnections
        target: contentLoader.item
        ignoreUnknownSignals: contentLoader.source !== root.__newQuizPath

        function onFinnished(correctAnswers) {
            contentLoader.setSource(root.__resultPath, {
                                        "correctAnswers": correctAnswers,
                                        "countOfQuestions": countOfQuestions
                                    })
        }
    }

    Connections {
        id: settingsDialogConnections
        target: settingsloader.item
        ignoreUnknownSignals: contentLoader.source !== root.__settingsDialogPath

        function onCountOfQuestionsChanged() {
            root.countOfQuestions = settingsloader.item.countOfQuestions
            reevaluateNewQuizButtonEnabled()
        }
        function onDarkModeOnChanged() {
            root.darkModeOn = settingsloader.item.darkModeOn
            selectColorMode()
        }
    }
    Connections {
        id: addNewQuestionDialogConnections
        target: addNewQuestionloader.item
        ignoreUnknownSignals: contentLoader.source !== root.__newAddNewQuestionDialog

        function onAccepted() {
            reevaluateNewQuizButtonEnabled()
        }
    }

    function loadSettings() {
        LanguageSelector.language = settings.language
        root.countOfQuestions = settings.countOfQuestions
        root.darkModeOn = settings.darkModeOn
        root.currentDatabasePath = settings.currentDatabasePath
    }

    function selectColorMode() {
        if (root.darkModeOn) {
            Material.theme = Material.Dark
        } else {
            Material.theme = Material.Light
        }
    }

    function saveSettings() {
        settings.language = LanguageSelector.language
        settings.countOfQuestions = root.countOfQuestions
        settings.darkModeOn = root.darkModeOn
        settings.currentDatabasePath = root.currentDatabasePath
    }

    function reevaluateNewQuizButtonEnabled() {
        if (root.countOfQuestions == 0) {
            newQuizButton.enabled = false
            return
        }
        if (root.currentDatabasePath == "") {
            newQuizButton.enabled = false
            return
        }
        if (contentLoader.source == root.__newQuizPath) {
            newQuizButton.enabled = false
            return
        }
        newQuizButton.enabled = QuestionsProxyModel.rowCount(
                    ) >= root.countOfQuestions
    }

    function reevaluateDatabaseButtonEnabled() {
        databaseButton.enabled = contentLoader.source != root.__newQuizPath
    }

    function reevaluateAddQuestionButtonEnabled() {
        addQuestionButton.enabled = contentLoader.source != root.__newQuizPath
    }

    function reevaluateSettingsButtonEnabled() {
        settingsButton.enabled = contentLoader.source != root.__newQuizPath
    }
}
