import QtQuick 2.15

Item {
    id: root

    property int correctAnswers
    property int countOfQuestions

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "green"
        Text {
            id: resultText
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("You answered %1 out of %2 questions correct").arg(
                      correctAnswers).arg(countOfQuestions)
            font.pointSize: 24
        }
    }
}
