import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Qt.labs.qmlmodels 1.0

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

        columnWidthProvider: function (column) {
            if (column === 0) {
                return 30
            }
            if (column === 6) {
                return 100
            }
            if (column === 7) {
                return 100
            }
            return 220
        }
        rowHeightProvider: function () {
            return -1
        }

        model: questionSqlTableModel

        delegate: TextFieldDelegate {
            implicitWidth: tableView.columnWidthProvider(tableView.column)
        }

        ScrollIndicator.vertical: ScrollIndicator {}
    }
}
