
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

Frame {
    property int row
    property string role

    property alias color: textArea.color
    property alias text: textArea.text

    property bool textModified: false

    signal valueChanged(int row, string value, string role)

    TextArea {
        anchors.fill: parent
        id: textArea
        Keys.onTabPressed: nextItemInFocusChain().forceActiveFocus(
                               Qt.TabFocusReason)

        wrapMode: TextArea.Wrap
        selectByMouse: true
        padding: 8
    }

    onFocusChanged: {
        if (!focus && textModified) {
            valueChanged(row, textArea.text, role)
            textModified = false
        }
    }
    onTextChanged: {
        if (focus) {
            textModified = true
        }
    }
}
