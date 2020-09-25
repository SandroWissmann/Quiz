import QtQuick 2.15
import QtQuick.Controls 2.15

import sandro.custom.types 1.0

Rectangle {
    id: tableView
    color: "#b56a6a"

    Component.onCompleted: {
        questionSqlTableModel.generateNewRandomQuestions(10)
        console.log(questionSqlTableModel.randomQuestions[0].id)
        console.log(questionSqlTableModel.randomQuestions[0].askedQuestion)
        console.log(questionSqlTableModel.randomQuestions[0].answer1)
        console.log(questionSqlTableModel.randomQuestions[0].answer2)
        console.log(questionSqlTableModel.randomQuestions[0].answer3)
        console.log(questionSqlTableModel.randomQuestions[0].answer4)

    }
}
