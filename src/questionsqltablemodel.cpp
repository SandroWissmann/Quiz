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
