import QtQuick 2.15
import QtQuick.Dialogs 1.2

FileDialog {
    title: qsTr("Please choose a Picture")
    folder: shortcuts.home
    nameFilters: [qsTr("Image files (*.png)")]
}
