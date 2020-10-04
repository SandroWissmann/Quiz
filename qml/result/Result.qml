import QtQuick 2.15
import QtQuick.Particles 2.15

Item {
    id: root

    required property int correctAnswers
    required property int countOfQuestions

    enum Grade{
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
            text: qsTr("You answered %1 out of %2 questions correct").arg(
                      correctAnswers).arg(countOfQuestions)
            font.pointSize: 24
        }
    }

    Loader{
        id: particleLoader
        anchors.fill: parent
    }

    Component.onCompleted: {
        var ratio = calcRatio(correctAnswers, countOfQuestions);
        var grade = getGrade(ratio)

        switch(grade){
        case Result.Grade.Perfect:
            particleLoader.setSource("PerfectAnimation.qml");
            break;
        case Result.Grade.Excellent:
            particleLoader.setSource("ExcellentAnimation.qml");
            break;
        case Result.Grade.VeryGood:
            particleLoader.setSource("VeryGoodAnimation.qml");
            break;
        case Result.Grade.Good:
            particleLoader.setSource("GoodAnimation.qml");
            break;
        case Result.Grade.Satisfactory:
            particleLoader.setSource("SatisfactoryAnimation.qml");
            break;
        case Result.Grade.Sufficient:
            particleLoader.setSource("SufficientAnimation.qml");
            break;
        case Result.Grade.Fail:
            particleLoader.setSource("FailAnimation.qml");
            break;
        }
    }

    function calcRatio(correctAnswers, countOfQuestions)
    {
        return correctAnswers / countOfQuestions;
    }

    function getGrade(ratio)
    {
        console.assert(ratio < 0.0 || ratio > 1.0);
        if (ratio >=1.0) {
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



//ParticleSystem {
//    id: sys
//    anchors.fill: parent

//    ImageParticle {
//        system: sys
//        id: cp
//        source: "qrc:///ressources/images/glowdot.png"
//        colorVariation: 0.4
//        color: "#0000FFFF"
//    }

//    Emitter {
//        id: bursty
//        system: sys
//        enabled: true
//        x: root.width / 3
//        y: root.height / 3
//        emitRate: 400
//        maximumEmitted: 100
//        acceleration: AngleDirection {angleVariation: 360; magnitude: 360; }
//        size: 8
//        endSize: 16
//        sizeVariation: 4
//    }
//}
