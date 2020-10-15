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

QVariant QuestionSqlTableModel::data(const QModelIndex &index, int role) const
{
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
