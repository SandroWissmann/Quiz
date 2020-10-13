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
}

QVariant RandomQuestionFilterModel::data(const QModelIndex &index, int role) const
{
    switch(role) {
    case idRole:
        return
    }
}

void RandomQuestionFilterModel::generateRandomQuestions(int count)
{
    mAcceptedRows.resize(sourceModel()->rowCount());
    std::iota(std::begin(mAcceptedRows), std::end(mAcceptedRows), 0);
    std::shuffle(std::begin(mAcceptedRows), std::end(mAcceptedRows),
                 std::mt19937(std::random_device()()));

    mAcceptedRows.resize(count);
}

bool RandomQuestionFilterModel::filterAcceptsRow(
        int source_row, const QModelIndex &source_parent) const
{
    Q_UNUSED(source_parent)
    auto it = std::find(mAcceptedRows.begin(), mAcceptedRows.end(), source_row);
    return it != mAcceptedRows.end();
}
