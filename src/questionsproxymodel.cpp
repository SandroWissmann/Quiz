#include "../include/questionsproxymodel.h"

#include "../include/questionsqlcolumnnames.h"

#include <QDebug>
#include <QPixmap>
#include <QBuffer>

#include <QByteArray>

QuestionsProxyModel::QuestionsProxyModel(QObject* parent)
    :QIdentityProxyModel(parent)
{
}

QHash<int, QByteArray> QuestionsProxyModel::roleNames() const
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

QVariant QuestionsProxyModel::headerData(int section,
                                         Qt::Orientation orientation, int role) const
{
    qDebug() << "headerData was called";
    if(orientation != Qt::Orientation::Horizontal) {
        return QVariant{};
    }

    if(role == Qt::DisplayRole) {
        switch (section) {
            case 0:
                return tr("Id");
            case 1:
                return tr("Question");
            case 2:
                return tr("Answer 1");
            case 3:
                return tr("Answer 2");
            case 4:
                return tr("Answer 3");
            case 5:
                return tr("Answer 4");
            case 6:
                return tr("Correct Answer");
            case 7:
                return tr("Picture");
        }
    }
    return QVariant{};
}

QVariant QuestionsProxyModel::data(const QModelIndex &index, int role) const
{
    QModelIndex newIndex = mapIndex(index, role);
    if (role == idRole
            || role == askedQuestionRole
            || role == answer1Role
            || role == answer2Role
            || role == answer3Role
            || role == answer4Role
            || role == correctAnswerRole
            || role == pictureRole) {

        return QIdentityProxyModel::data(newIndex, Qt::DisplayRole);
    }
    return QIdentityProxyModel::data(newIndex, role);
}

//bool QuestionsProxyModel::addNewEntry(const QString &askedQuestion,
//                                    const QString &answer1,
//                                    const QString &answer2,
//                                    const QString &answer3,
//                                    const QString &answer4,
//                                    int correctAnswer,
//                                    const QString &picturePath)
//{
//    Q_ASSERT(!askedQuestion.isEmpty());
//    Q_ASSERT(!answer1.isEmpty());
//    Q_ASSERT(!answer2.isEmpty());
//    Q_ASSERT(!answer3.isEmpty());
//    Q_ASSERT(!answer4.isEmpty());
//    Q_ASSERT(correctAnswer >= 1 && correctAnswer <= 4);


//    auto newRow = rowCount();

//    if(!insertRow(newRow, QModelIndex{})) {
//        return false;
//    }
//    if(!setData(index(newRow, QuestionColumn::id), newRow)) {
//        sourceModel()->removeRows(newRow , 1);
//        return false;
//    }
//    if(!setData(index(newRow, QuestionColumn::askedQuestion),
//                           askedQuestion)) {
//        removeRows(newRow , 1);
//        return false;
//    }
//    if(!setData(index(newRow, QuestionColumn::answer1), answer1)) {
//        removeRows(newRow, 1);
//        return false;
//    }
//    if(!setData(index(newRow, QuestionColumn::answer2), answer2)) {
//        removeRows(newRow, 1);
//        return false;
//    }
//    if(!setData(index(newRow, QuestionColumn::answer3), answer3)) {
//        removeRows(newRow, 1);
//        return false;
//    }
//    if(!setData(index(newRow, QuestionColumn::answer4), answer4)) {
//        removeRows(newRow, 1);
//        return false;
//    }
//    if(!setData(index(newRow, QuestionColumn::correct_answer), correctAnswer)) {
//        sourceModel()->removeRows(newRow, 1);
//        return false;
//    }
//    if(!setData(index(newRow, QuestionColumn::picture), picturePath)) {
//        removeRows(newRow, 1);
//        return false;
//    }
//    return true;
//}

QModelIndex QuestionsProxyModel::mapIndex(const QModelIndex &source, int role) const
{
    switch(role) {
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
