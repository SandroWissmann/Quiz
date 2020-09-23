import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import Qt.labs.qmlmodels 1.0

ApplicationWindow {
    visible: true
    //width: 640
    width: 1700
    height: 480
    title: qsTr("Quiz")

    SqlTableView{}
}


