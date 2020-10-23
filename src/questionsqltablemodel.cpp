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
    setEditStrategy(EditStrategy::OnFieldChange);
}

QVariant QuestionSqlTableModel::data(const QModelIndex &index, int role) const
{
    if(role == Qt::DisplayRole && index.column() == QuestionColumn::picture) {
        return QSqlTableModel::data(index, role).toByteArray().toBase64();
    }
    return QSqlTableModel::data(index, role);
}

bool QuestionSqlTableModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    qDebug() << "index:" << index.column();
    qDebug() << "value:" << value;
    if(role == Qt::DisplayRole && index.column() == QuestionColumn::picture) {
        auto picturePath = value.toString();

        QByteArray picture;
        if(!picturePath.isEmpty()) {
           QPixmap inPixmap;
           if (inPixmap.load(picturePath)) {
               QBuffer inBuffer(&picture);
               inBuffer.open( QIODevice::WriteOnly );
               inPixmap.save(&inBuffer, "PNG");
           }
        }
        return QSqlTableModel::setData(index, picture, role);
    }
    return QSqlTableModel::setData(index, value, role);
}
