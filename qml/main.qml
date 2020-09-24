import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Qt.labs.qmlmodels 1.0

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
            }
            ToolButton {
                text: qsTr("Show Table")
                icon.name: "document-open"
                onClicked: {
                    console.log("clicked")
                    loader.source = "SqlTableView.qml"
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


