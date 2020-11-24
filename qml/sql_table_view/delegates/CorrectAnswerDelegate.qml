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
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Frame {
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
