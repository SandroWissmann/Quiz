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
import QtQuick.Particles 2.15

Item {
    id: root

    property int correctAnswers
    property int countOfQuestions

    enum Grade {
        Perfect,
        Excellent,
        VeryGood,
        Good,
        Satisfactory,
        Sufficient,
        Fail
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "black"
        Text {
            id: resultText
            color: "white"
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("You answered %1 out of %2 questions correct.").arg(
                      correctAnswers).arg(countOfQuestions)
            font.pointSize: 24
        }
    }

    Loader {
        id: particleLoader
        anchors.fill: parent
    }

    Component.onCompleted: {
        var ratio = calcRatio(correctAnswers, countOfQuestions)
        var grade = getGrade(ratio)

        switch (grade) {
        case Result.Grade.Perfect:
            particleLoader.setSource("PerfectAnimation.qml")
            break
        case Result.Grade.Excellent:
            particleLoader.setSource("ExcellentAnimation.qml")
            break
        case Result.Grade.VeryGood:
            particleLoader.setSource("VeryGoodAnimation.qml")
            break
        case Result.Grade.Good:
            particleLoader.setSource("GoodAnimation.qml")
            break
        case Result.Grade.Satisfactory:
            particleLoader.setSource("SatisfactoryAnimation.qml")
            break
        case Result.Grade.Sufficient:
            particleLoader.setSource("SufficientAnimation.qml")
            break
        case Result.Grade.Fail:
            particleLoader.setSource("FailAnimation.qml")
            break
        }
    }

    function calcRatio(correctAnswers, countOfQuestions) {
        return correctAnswers / countOfQuestions
    }

    function getGrade(ratio) {
        console.assert(ratio >= 0.0 && ratio <= 1.0)
        if (ratio >= 1.0) {
            return Result.Grade.Perfect
        }
        if (ratio >= 0.9) {
            return Result.Grade.Excellent
        }
        if (ratio >= 0.8) {
            return Result.Grade.VeryGood
        }
        if (ratio >= 0.7) {
            return Result.Grade.Good
        }
        if (ratio >= 0.6) {
            return Result.Grade.Satisfactory
        }
        if (ratio >= 0.5) {
            return Result.Grade.Sufficient
        }
        return Result.Grade.Fail
    }
}
