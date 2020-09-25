import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Qt.labs.qmlmodels 1.0

import "add_new_question_dialog"
import "sql_table_view"

ApplicationWindow {
    visible: true
    //width: 640
    width: 1700
    height: 800
    title: qsTr("Quiz")

    Loader{
        id: loader
        anchors.fill: parent
    }

    menuBar: ToolBar {
        Flow {
            anchors.fill: parent
            ToolButton {
                text: qsTr("New Quiz")
                icon.name: "address-book-new"
                onClicked: {
                    loader.source = "quiz/Quiz.qml"
                }
            }
            ToolButton {
                text: qsTr("Show Table")
                icon.name: "document-open"
                onClicked: {
                    loader.source = "sql_table_view/SqlTableView.qml"
                }
            }
            ToolButton {
                text: qsTr("Add Question")
                icon.name: "document-new"
                onClicked: addQuestionDialog.open()
            }
        }

        AddNewQuestionDialog{
            id: addQuestionDialog
        }
    }
}


