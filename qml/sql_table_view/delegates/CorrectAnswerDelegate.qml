import QtQuick 2.15
import QtQuick.Controls 2.15

SpinBox {
    property int row

    signal valueChanged(int row, int value, string role)

    id: spinbox
    from: 1
    to: 4

    onValueModified: {
        valueChanged(row, value, "correctAnswer")
    }
}
