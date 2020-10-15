#include "../include/randomquestionfiltermodel.h"

#include <algorithm>
#include <random>

#include <QDebug>

RandomQuestionFilterModel::RandomQuestionFilterModel(QObject *parent)
    :QSortFilterProxyModel{parent}
{
}

QHash<int, QByteArray> RandomQuestionFilterModel::roleNames() const
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

QVariant RandomQuestionFilterModel::data(const QModelIndex &index, int role) const
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
    return QSortFilterProxyModel::data(index, role);
}

void RandomQuestionFilterModel::generateRandomQuestions(int count)
{
    beginResetModel();

    mAcceptedRows.resize(sourceModel()->rowCount());
    std::iota(std::begin(mAcceptedRows), std::end(mAcceptedRows), 0);
    std::shuffle(std::begin(mAcceptedRows), std::end(mAcceptedRows),
                 std::mt19937(std::random_device()()));

    mAcceptedRows.resize(count);

    endResetModel();
}

bool RandomQuestionFilterModel::filterAcceptsRow(
        int source_row, const QModelIndex &source_parent) const
{
    Q_UNUSED(source_parent)
    auto it = std::find(mAcceptedRows.begin(), mAcceptedRows.end(), source_row);
    return it != mAcceptedRows.end();
}
