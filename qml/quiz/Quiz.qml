import QtQuick 2.15
import QtQuick.Controls 2.15

import sandro.custom.types 1.0

Item {
    id: tableView


    width: parent.width
    height: parent.height

    //color: "#b56a6a"

//    Component.onCompleted: {
//        console.log(questionSqlTableModel.randomQuestions[0])
//        console.log(questionSqlTableModel.randomQuestions[0].id)
//        console.log(questionSqlTableModel.randomQuestions[0].askedQuestion)
//        console.log(questionSqlTableModel.randomQuestions[0].answer1)
//        console.log(questionSqlTableModel.randomQuestions[0].answer2)
//        console.log(questionSqlTableModel.randomQuestions[0].answer3)
//        console.log(questionSqlTableModel.randomQuestions[0].answer4)
//        console.log(questionSqlTableModel.randomQuestions[0].picture)
//    }

    QuestionPage{
        id: questionpage
        question: questionSqlTableModel.randomQuestions[0]
    }

//    Component{
//        id: questionDialogComponent

//        QuestionDialog{
//            id: questionDialog
//            question: questionSqlTableModel.randomQuestions[0]
//        }
//    }

//    Component{
//        id: imageComponent
//    Image{
//        id: image
//        anchors.fill: parent

//        source: questionSqlTableModel.randomQuestions[0].picture.length > 0 ?
//                    "data:image/png;base64," + questionSqlTableModel.randomQuestions[0].picture: ""
//    }}

//    StackView{
//        width: parent.width
//        height: parent.height

//        id: stack
//        initialItem: questionDialogComponent
//        anchors.fill: parent
//    }
}
