import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Qt.labs.qmlmodels 1.0
import Qt.labs.settings 1.0
import QtQuick.Controls.Material 2.12

import LanguageSelectors 1.0

import "add_new_question_dialog"
import "sql_table_view"
import "settings_dialog"

ApplicationWindow {
    id: root
    visible: true
    width: __defaultWidth // 680    // 1370
    height: 800
    title: qsTr("Quiz")

    Material.theme: Material.Light
    Material.primary: Material.LightBlue
    Material.accent: Material.Blue

    readonly property int __showTableWidth: 1370
    readonly property int __defaultWidth: 680

    property int countOfQuestions

    readonly property string __newQuizPath: "qrc:/qml/quiz/Quiz.qml"
    readonly property string __newShowTablePath: "qrc:/qml/sql_table_view/SqlTableView.qml"
    readonly property string __newAddNewQuestionDialog: "qrc:/qml/add_new_question_dialog/AddNewQuestionDialog.qml"
    readonly property string __resultPath: "qrc:/qml/result/Result.qml"
    readonly property string __settingsDialogPath: "qrc:/qml/settings_dialog/SettingsDialog.qml"

    Settings {
        id: settings
        property int language: LanguageSelector.German
        property int countOfQuestions: 10
    }
    Component.onCompleted: {
        showButtonsIfConditionsAreMet()
        LanguageSelector.language = settings.language
        root.countOfQuestions = settings.countOfQuestions
    }

    Component.onDestruction: {
        settings.language = LanguageSelector.language
        settings.countOfQuestions = root.countOfQuestions
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
                                                     "countOfQuestions": root.countOfQuestions
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

    onWidthChanged: console.log("width: " + width)
    onHeightChanged: console.log("height: " + height)
}
