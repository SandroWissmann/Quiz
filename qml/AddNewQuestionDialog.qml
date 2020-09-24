import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Dialogs 1.2 as Dialogs

Controls.Dialog {
    id: dialog
    x: 100
    y: 100
    width: 500
    height: 500
    modal: true
    focus: true
    closePolicy: Controls.Popup.CloseOnEscape | Controls.Popup.CloseOnPressOutsideParent

    title: "Enter new Question"

    Controls.ButtonGroup {
        id: radioGroup
    }

    contentItem:

    ColumnLayout{
        RowLayout{
            Text{
                text: qsTr("Question:")
            }
            TextInput{
                Layout.fillWidth: true
                id: questionTextInput
                text: qsTr("question")
                selectByMouse: true
            }
        }
        RowLayout{
            Text{
                text: qsTr("Answer1:")
            }
            TextInput{
                Layout.fillWidth: true
                id: answer1TextInput
                text: qsTr("answer1")
                selectByMouse: true
            }
            Controls.RadioButton{
                id: radioButtonAnswer1
                Controls.ButtonGroup.group: radioGroup
                checked: true
            }
        }
        RowLayout{
            Text{
                text: qsTr("Answer2:")
            }
            TextInput{
                Layout.fillWidth: true
                id: answer2TextInput
                text: qsTr("answer2")
                selectByMouse: true
            }
            Controls.RadioButton{
                id: radioButtonAnswer2
                Controls.ButtonGroup.group: radioGroup
            }
        }
        RowLayout{
            Text{
                text: qsTr("Answer3:")
            }
            TextInput{
                Layout.fillWidth: true
                id: answer3TextInput
                text: qsTr("answer3")
                selectByMouse: true
            }
            Controls.RadioButton{
                id: radioButtonAnswer3
                Controls.ButtonGroup.group: radioGroup
            }
        }
        RowLayout{
            Text{
                text: qsTr("Answer4:")
            }
            TextInput{
                Layout.fillWidth: true
                id: answer4TextInput
                text: qsTr("answer4")
                selectByMouse: true
            }
            Controls.RadioButton{
                id: radioButtonAnswer4
                Controls.ButtonGroup.group: radioGroup
            }
        }
        RowLayout{
            Image{
                id: questionImage
            }
        }
        RowLayout{
            TextInput{
                Layout.fillWidth: true
                id: imagePathTextInput
                selectByMouse: true
            }
            Controls.Button{
                id: fileDialogButton
                text: qsTr("select Image")
                onPressed: fileDialog.open()
            }
        }


        Dialogs.FileDialog {
            id: fileDialog
            title: qsTr("Please choose a file")
            folder: shortcuts.home
            onAccepted: {
                console.log("You chose: " + fileDialog.fileUrls)
            }
            onRejected: {
                console.log("Canceled")
            }
        }
    }





    standardButtons: Controls.Dialog.Ok | Controls.Dialog.Cancel

    onAccepted: console.log("Ok clicked")
    onRejected: console.log("Cancel clicked")
}
