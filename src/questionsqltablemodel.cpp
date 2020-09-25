#include "../include/questionsqltablemodel.h"

#include "../include/questionsqlcolumnnames.h"

#include "../include/question.h"

#include <QDebug>
#include <QPixmap>
#include <QBuffer>

#include <QSqlRecord>
#include <QSqlError>
#include <QSqlField>
#include <QSqlRelationalDelegate>

#include <algorithm>
#include <random>

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

void QuestionSqlTableModel::generateNewRandomQuestions(int count)
{
    QVector<int> rows(rowCount());
    std::iota(std::begin(rows), std::end(rows), 0);
    std::shuffle(std::begin(rows), std::end(rows),
                 std::mt19937(std::random_device()()));

    QVector<QSqlRecord> sqlRecords;
    for(auto it = rows.begin();
        it < rows.end() && it < (rows.begin() + count); ++it) {
        auto sqlRecord = record(*it);
        sqlRecords.push_back(sqlRecord);
    }

    QVector<Question*> questions;
    questions.reserve(sqlRecords.size());

    for(const auto& sqlRecord : sqlRecords) {
        auto question = new Question{
            sqlRecord.value(QuestionColumn::id).toInt(),
            sqlRecord.value(QuestionColumn::askedQuestion).toString(),
            sqlRecord.value(QuestionColumn::answer1).toString(),
            sqlRecord.value(QuestionColumn::answer2).toString(),
            sqlRecord.value(QuestionColumn::answer3).toString(),
            sqlRecord.value(QuestionColumn::answer4).toString(),
            static_cast<Question::Correct>(
                sqlRecord.value(QuestionColumn::correct_answer).toInt()),
            sqlRecord.value(QuestionColumn::picture).toByteArray().toBase64()
        };

        questions.push_back(question);
    }
    mRandomQuestions = questions;
}

QQmlListProperty <Question> QuestionSqlTableModel::getRandomQuestions()
    {
        return {this,this,
                  &QuestionSqlTableModel::appendRandomQuestion,
                  &QuestionSqlTableModel::randomQuestionsCount,
                  &QuestionSqlTableModel::randomQuestionAt,
                  &QuestionSqlTableModel::randomQuestionsClear};
    }

void QuestionSqlTableModel::appendRandomQuestion(Question *question)
{
   mRandomQuestions.append(question);
   emit randomQuestionsChanged();
 }

int QuestionSqlTableModel::randomQuestionsCount() const
{
    return mRandomQuestions.size();
}

Question* QuestionSqlTableModel::randomQuestionAt(int index) const
{
    return mRandomQuestions[index];
}

void QuestionSqlTableModel::randomQuestionsClear()
{
    mRandomQuestions.clear();
    emit randomQuestionsChanged();
}

void QuestionSqlTableModel::appendRandomQuestion(
        QQmlListProperty<Question> *list, Question *question)
{
    reinterpret_cast<QuestionSqlTableModel*>(
                list->data)->appendRandomQuestion(question);
}

int QuestionSqlTableModel::randomQuestionsCount(
        QQmlListProperty<Question> *list)
{
    return reinterpret_cast<QuestionSqlTableModel*>(
                list->data)->randomQuestionsCount();
}

Question *QuestionSqlTableModel::randomQuestionAt(
        QQmlListProperty<Question> *list, int index)
{
    return reinterpret_cast<QuestionSqlTableModel*>(
                list->data)->randomQuestionAt(index);
}

void QuestionSqlTableModel::randomQuestionsClear(
        QQmlListProperty<Question> *list)
{
    return reinterpret_cast<QuestionSqlTableModel*>(
                list->data)->randomQuestionsClear();
}

