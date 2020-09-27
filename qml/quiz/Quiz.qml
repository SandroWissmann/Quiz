import QtQuick 2.15
import QtQuick.Controls 2.15

import sandro.custom.types 1.0

Rectangle {
    id: tableView
    color: "#b56a6a"

    Component.onCompleted: {
        console.log(questionSqlTableModel.randomQuestions[0].id)
        console.log(questionSqlTableModel.randomQuestions[0].askedQuestion)
        console.log(questionSqlTableModel.randomQuestions[0].answer1)
        console.log(questionSqlTableModel.randomQuestions[0].answer2)
        console.log(questionSqlTableModel.randomQuestions[0].answer3)
        console.log(questionSqlTableModel.randomQuestions[0].answer4)
        console.log(questionSqlTableModel.randomQuestions[0].picture)
    }

    Image{
        id: image
        anchors.fill: parent

        source: questionSqlTableModel.randomQuestions[0].picture.length > 0 ?
                    "data:image/png;base64," + questionSqlTableModel.randomQuestions[0].picture: ""
    }
}
