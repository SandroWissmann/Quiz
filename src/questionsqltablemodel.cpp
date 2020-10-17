#include "../include/questionsqltablemodel.h"

#include "../include/questionsqlcolumnnames.h"

#include <QDebug>
#include <QPixmap>
#include <QBuffer>

#include <QSqlRecord>
#include <QSqlError>
#include <QSqlField>
#include <QSqlRelationalDelegate>

QuestionSqlTableModel::QuestionSqlTableModel(
    QObject *parent, const QSqlDatabase &db)
    : QSqlTableModel{parent, db}
{
}

QHash<int, QByteArray> QuestionSqlTableModel::roleNames() const
{
    QHash <int,QByteArray> roles;
    roles[idRole] = "id";
    roles[askedQuestionRole] = "askedQuestion";
    roles[answer1Role] = "answer1";
    roles[answer2Role] = "answer2";
    roles[answer3Role] = "answer3";
    roles[answer4Role] = "answer4";
    roles[correctAnswerRole] = "correctAnswer";
    roles[pictureRole] = "picture";

    return roles;
}

QVariant QuestionSqlTableModel::data(const QModelIndex &index, int role) const
{
    switch(role) {
    case idRole:
        return index.sibling(index.row(), 0).data().toInt();
    case askedQuestionRole:
        return index.sibling(index.row(), 1).data().toString();
    case answer1Role:
        return index.sibling(index.row(), 2).data().toString();
    case answer2Role:
        return index.sibling(index.row(), 3).data().toString();
    case answer3Role:
        return index.sibling(index.row(), 4).data().toString();
    case answer4Role:
        return index.sibling(index.row(), 5).data().toString();
    case correctAnswerRole:
        return index.sibling(index.row(), 6).data().toInt();
    case pictureRole:
        return index.sibling(index.row(), 7).data().toByteArray().toBase64();
    }
    return QSqlTableModel::data(index, role);
}

bool QuestionSqlTableModel::addNewEntry(const QString& askedQuestion,
        const QString& answer1,
        const QString& answer2,
        const QString& answer3,
        const QString& answer4,
        int correctAnswer,
        const QString& picturePath)
{
    Q_ASSERT(!askedQuestion.isEmpty());
    Q_ASSERT(!answer1.isEmpty());
    Q_ASSERT(!answer2.isEmpty());
    Q_ASSERT(!answer3.isEmpty());
    Q_ASSERT(!answer4.isEmpty());
    Q_ASSERT(correctAnswer >= 1 && correctAnswer <= 4);

    QByteArray picture;
    if(!picturePath.isEmpty()) {
       QPixmap inPixmap;
       if (inPixmap.load(picturePath)) {
           QBuffer inBuffer(&picture);
           inBuffer.open( QIODevice::WriteOnly );
           inPixmap.save(&inBuffer, "PNG");
       }
    }

    database().transaction();

    auto sqlRecord = record();
    sqlRecord.setValue(QuestionColumn::askedQuestion, askedQuestion);
    sqlRecord.setValue(QuestionColumn::answer1, answer1);
    sqlRecord.setValue(QuestionColumn::answer2, answer2);
    sqlRecord.setValue(QuestionColumn::answer3, answer3);
    sqlRecord.setValue(QuestionColumn::answer4, answer4);
    sqlRecord.setValue(QuestionColumn::correct_answer, correctAnswer);
    sqlRecord.setValue(QuestionColumn::picture, picture);

    if(!insertRecord(-1, sqlRecord)) {
        qDebug() << "Failed to set record" <<
             "The database reported an error: " <<
               lastError().text()
        <<"RowCount" <<rowCount();
        return false;
    }

    if(submitAll()) {
        database().commit();
        select();
        return true;
    }
    database().rollback();
            qDebug() << "Database Write Error" <<
                 "The database reported an error: " <<
                   lastError().text();
            return false;
}
