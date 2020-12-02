
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
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import QuestionsProxyModels 1.0

Dialog {
    id: dialog
    x: 100
    y: 100
    width: 500
    height: 600
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    title: qsTr("Enter new Question")

    onOpened: {
        standardButton(Dialog.Ok).enabled = false
        standardButton(Dialog.Ok).text = qsTr("OK")
        standardButton(Dialog.Cancel).text = qsTr("Cancel")
    }

    ButtonGroup {
        id: radioGroup
    }

    contentItem: ColumnLayout {
        RowLayout {
            Label {
                text: qsTr("Question:")
            }
            TextField {
                id: questionTextField
                Layout.fillWidth: true
                selectByMouse: true
                onTextChanged: {
                    if (dataIsValid()) {
                        dialog.standardButton(Dialog.Ok).enabled = true
                    }
                }
            }
        }
        RowLayout {
            Label {
                text: qsTr("Answer1:")
            }
            TextField {
                id: answer1TextField
                Layout.fillWidth: true
                selectByMouse: true
                onTextChanged: {
                    if (dataIsValid()) {
                        dialog.standardButton(Dialog.Ok).enabled = true
                    }
                }
            }
            RadioButton {
                id: radioButtonAnswer1
                ButtonGroup.group: radioGroup
                checked: true
            }
        }
        RowLayout {
            Label {
                text: qsTr("Answer2:")
            }
            TextField {
                id: answer2TextField
                Layout.fillWidth: true
                selectByMouse: true
                onTextChanged: {
                    if (dataIsValid()) {
                        dialog.standardButton(Dialog.Ok).enabled = true
                    }
                }
            }
            RadioButton {
                id: radioButtonAnswer2
                ButtonGroup.group: radioGroup
            }
        }
        RowLayout {
            Label {
                text: qsTr("Answer3:")
            }
            TextField {
                id: answer3TextField
                Layout.fillWidth: true
                selectByMouse: true
                onTextChanged: {
                    if (dataIsValid()) {
                        dialog.standardButton(Dialog.Ok).enabled = true
                    }
                }
            }
            RadioButton {
                id: radioButtonAnswer3
                ButtonGroup.group: radioGroup
            }
        }
        RowLayout {
            Label {
                text: qsTr("Answer4:")
            }
            TextField {
                id: answer4TextField
                Layout.fillWidth: true
                selectByMouse: true
                onTextChanged: {
                    if (dataIsValid()) {
                        dialog.standardButton(Dialog.Ok).enabled = true
                    }
                }
            }
            RadioButton {
                id: radioButtonAnswer4
                ButtonGroup.group: radioGroup
            }
        }
        RowLayout {
            Image {
                id: questionImage
            }
        }
        RowLayout {
            TextField {
                id: imagePathTextField
                Layout.fillWidth: true
                selectByMouse: true
            }
            Button {
                id: fileDialogButton
                text: qsTr("select Image")
                onPressed: pictureFileDialog.open()
            }
        }
        Image {
            id: previewPictureImage
            Layout.fillWidth: true
            Layout.fillHeight: true
            fillMode: Image.PreserveAspectFit
            sourceSize.width: 1024
            sourceSize.height: 1024
        }
        PictureFileDialog {
            id: pictureFileDialog
            onAccepted: {
                imagePathTextField.text = pictureFileDialog.fileUrl
                previewPictureImage.source = pictureFileDialog.fileUrl
            }
        }
    }

    standardButtons: Dialog.Ok | Dialog.Cancel

    onAccepted: {
        var imagePath = imagePathTextField.text
        imagePath = imagePath.replace("file://", "")

        var added = QuestionsProxyModel.addNewEntry(questionTextField.text,
                                                    answer1TextField.text,
                                                    answer2TextField.text,
                                                    answer3TextField.text,
                                                    answer4TextField.text,
                                                    correctAnswerAsInt(),
                                                    imagePath)
        if (!added) {
            console.log("Could not add to database")
        }
    }

    function dataIsValid() {
        return questionTextField.text !== "" && answer1TextField.text !== ""
                && answer2TextField.text !== "" && answer3TextField.text !== ""
                && answer4TextField.text !== ""
    }

    function correctAnswerAsInt() {
        if (radioButtonAnswer1.checked) {
            return 1
        }
        if (radioButtonAnswer2.checked) {
            return 2
        }
        if (radioButtonAnswer3.checked) {
            return 3
        }
        if (radioButtonAnswer4.checked) {
            return 4
        }
        return -1
    }
}
