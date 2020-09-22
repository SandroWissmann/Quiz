import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

ApplicationWindow {
    visible: true
    //width: 640
    width: 1700
    height: 480
    title: qsTr("Quiz")

    TableView {
        id: tableView
        boundsBehavior: Flickable.StopAtBounds
        reuseItems: true
        clip: true

        columnWidthProvider: function (column) {
            if(column === 0) {
                return 30;
            }
            if(column === 6){
                return 100;
            }
            if(column === 7) {
                return 100
            }
            return 220;
        }
        rowHeightProvider: function() { return -1 }
        anchors.fill: parent
        topMargin: columnsHeader.implicitHeight

        model: questionSqlTableModel

        delegate: Rectangle{
            id: rect
            implicitHeight: 50
            implicitWidth: tableView.columnWidthProvider(tableView.column)
            border.width: 1

            TextEdit{
                //height: rect.implicitHeight
                width: rect.implicitWidth
                id: displayText
                text: modelData
                wrapMode: TextEdit.WordWrap
            }
        }

        ScrollIndicator.vertical: ScrollIndicator { }

        // display header
        Row{
            id: columnsHeader
            y: tableView.contentY
            z: 2

            Repeater {
                model: tableView.columns > 0 ? tableView.columns : 1

                Text {
                    id: labelRow
                    width: tableView.columnWidthProvider(index)
                    height: tableView.rowHeightProvider()
                    text: questionSqlTableModel.headerData(modelData, Qt.Horizontal)
                }
            }
        }
    }
}


