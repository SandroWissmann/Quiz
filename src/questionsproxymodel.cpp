#include "../include/questionsproxymodel.h"

#include "../include/questionsqlcolumnnames.h"

#include <QBuffer>
#include <QDebug>
#include <QPixmap>

#include <QByteArray>

#include <QSqlError>
#include <QSqlTableModel>

QuestionsProxyModel::QuestionsProxyModel(QObject *parent)
    : QIdentityProxyModel(parent)
{
}

QHash<int, QByteArray> QuestionsProxyModel::roleNames() const
{
    QHash<int, QByteArray> roles;
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

QVariant QuestionsProxyModel::data(const QModelIndex &index, int role) const
{
    QModelIndex newIndex = mapIndex(index, role);
    if (role == idRole || role == askedQuestionRole || role == answer1Role ||
        role == answer2Role || role == answer3Role || role == answer4Role ||
        role == correctAnswerRole || role == pictureRole) {

        return QIdentityProxyModel::data(newIndex, Qt::DisplayRole);
    }
    return QIdentityProxyModel::data(newIndex, role);
}

bool QuestionsProxyModel::setData(const QModelIndex &index,
                                  const QVariant &value, int role)
{
    QModelIndex newIndex = mapIndex(index, role);

    if (role == idRole || role == askedQuestionRole || role == answer1Role ||
        role == answer2Role || role == answer3Role || role == answer4Role ||
        role == correctAnswerRole || role == pictureRole) {

        return QIdentityProxyModel::setData(newIndex, value, Qt::EditRole);
    }
    return QIdentityProxyModel::setData(newIndex, value, role);
}

bool QuestionsProxyModel::addNewEntry(const QString &askedQuestion,
                                      const QString &answer1,
                                      const QString &answer2,
                                      const QString &answer3,
                                      const QString &answer4, int correctAnswer,
                                      const QString &picturePath)
{
    Q_ASSERT(!askedQuestion.isEmpty());
    Q_ASSERT(!answer1.isEmpty());
    Q_ASSERT(!answer2.isEmpty());
    Q_ASSERT(!answer3.isEmpty());
    Q_ASSERT(!answer4.isEmpty());
    Q_ASSERT(correctAnswer >= 1 && correctAnswer <= 4);

    auto newRow = rowCount();

    if (!insertRows(newRow, 1)) {
        return false;
    }
    if (!setData(createIndex(newRow, QuestionColumn::id), newRow + 1)) {
        removeRows(newRow, 1);
        return false;
    }
    if (!setData(createIndex(newRow, QuestionColumn::askedQuestion),
                 askedQuestion)) {
        removeRows(newRow, 1);
        return false;
    }
    if (!setData(createIndex(newRow, QuestionColumn::answer1), answer1)) {
        removeRows(newRow, 1);
        return false;
    }
    if (!setData(createIndex(newRow, QuestionColumn::answer2), answer2)) {
        removeRows(newRow, 1);
        return false;
    }
    if (!setData(createIndex(newRow, QuestionColumn::answer3), answer3)) {
        removeRows(newRow, 1);
        return false;
    }
    if (!setData(createIndex(newRow, QuestionColumn::answer4), answer4)) {
        removeRows(newRow, 1);
        return false;
    }
    if (!setData(createIndex(newRow, QuestionColumn::correct_answer),
                 correctAnswer)) {
        removeRows(newRow, 1);
        return false;
    }
    if (!setData(createIndex(newRow, QuestionColumn::picture), picturePath)) {
        removeRows(newRow, 1);
        return false;
    }

    return saveIfIsSQLDatabase();
}

void QuestionsProxyModel::edit(int row, const QVariant &value,
                               const QString &role)
{
    setData(createIndex(row, 0), value, roleNames().key(role.toUtf8()));
}

QModelIndex QuestionsProxyModel::mapIndex(const QModelIndex &source,
                                          int role) const
{
    switch (role) {
    case idRole:
        return createIndex(source.row(), QuestionColumn::id);
    case askedQuestionRole:
        return createIndex(source.row(), QuestionColumn::askedQuestion);
    case answer1Role:
        return createIndex(source.row(), QuestionColumn::answer1);
    case answer2Role:
        return createIndex(source.row(), QuestionColumn::answer2);
    case answer3Role:
        return createIndex(source.row(), QuestionColumn::answer3);
    case answer4Role:
        return createIndex(source.row(), QuestionColumn::answer4);
    case correctAnswerRole:
        return createIndex(source.row(), QuestionColumn::correct_answer);
    case pictureRole:
        return createIndex(source.row(), QuestionColumn::picture);
    }
    return source;
}

bool QuestionsProxyModel::saveIfIsSQLDatabase()
{
    auto sqlModel = qobject_cast<QSqlTableModel *>(sourceModel());
    if (!sqlModel) {
        return false;
    }
    if (!sqlModel->submit()) {
        auto error = sqlModel->lastError();
        qDebug() << error.text();
        return false;
    }
    return true;
}
