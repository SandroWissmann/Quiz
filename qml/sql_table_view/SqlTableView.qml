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

        property var columnWidths: [30, 220, 220, 220, 220, 220, 100, 100]
        columnWidthProvider: function (column) {
            return columnWidths[column]
        }
        rowHeightProvider: function () {
            return -1
        }

        model: questionSqlTableModel

        delegate: Loader {
            id: loader
            source: getSourceFile(column)

            Component.onCompleted: {
                setItemProperties(column)
            }

            function getSourceFile(column) {
                switch (column) {
                case 0:
                    return "data/QuestionId.qml"
                case 1:
                    return "data/AskedQuestion.qml"
                case 2:
                    return "data/Answer1.qml"
                case 3:
                    return "data/Answer2.qml"
                case 4:
                    return "data/Answer3.qml"
                case 5:
                    return "data/Answer4.qml"
                case 6:
                    return "data/CorrectAnswer.qml"
                case 7:
                    return "data/Picture.qml"
                }
            }

            function setItemProperties(column) {
                loader.item.implicitWidth = tableView.columnWidthProvider(
                            column)
                switch (column) {
                case 0:
                    loader.item.text = id
                    break
                case 1:
                    loader.item.text = askedQuestion
                    break
                case 2:
                    loader.item.text = answer1
                    break
                case 3:
                    loader.item.text = answer2
                    break
                case 4:
                    loader.item.text = answer3
                    break
                case 5:
                    loader.item.text = answer4
                    break
                case 6:
                    loader.item.text = correctAnswer
                    break
                case 7:
                    loader.item.text = picture
                    break
                }
            }
        }

        ScrollIndicator.vertical: ScrollIndicator {}
    }

    Component.onCompleted: {

        /*
        Workarround:
        Table view cells get dynamically filled with loader. If forceLayout is
        not used at the end the tableView is not properly populated with the
        implicitWidth and the data for all the cells.
        */
        tableView.forceLayout()
    }
}
