#include "../include/questionsqltablemodel.h"

#include "../include/questionsqlcolumnnames.h"

QuestionSqlTableModel::QuestionSqlTableModel(
    QObject *parent, const QSqlDatabase &db)
    : QSqlTableModel{parent, db}
{
}

QVariant QuestionSqlTableModel::data(const QModelIndex &index, int role) const
{
    return QSqlTableModel::data(index, role);
}
