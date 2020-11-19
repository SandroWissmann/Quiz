import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root

    property int row
    property alias value: spinBox.value

    signal correctAnswerChanged(int row, int value, string role)

    ColumnLayout {
        Item {
            Layout.fillHeight: true
        }
        SpinBox {
            Layout.fillWidth: true
            id: spinBox

            signal valueChanged(int row, int value, string role)

            from: 1
            to: 4

            onValueModified: {
                correctAnswerChanged(row, value, "correctAnswer")
            }
        }
    }
}
