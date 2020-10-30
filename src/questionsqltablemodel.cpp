#include "../include/questionsqltablemodel.h"

#include "../include/questionsqlcolumnnames.h"

#include <QBuffer>
#include <QDebug>
#include <QPixmap>

#include <QSqlError>
#include <QSqlField>
#include <QSqlRecord>
#include <QSqlRelationalDelegate>

QuestionSqlTableModel::QuestionSqlTableModel(QObject *parent,
                                             const QSqlDatabase &db)
    : QSqlTableModel{parent, db}
{
    setTable("questions");
    setSort(QuestionColumn::id, Qt::AscendingOrder);
    select();
    setEditStrategy(EditStrategy::OnFieldChange);
}

QVariant QuestionSqlTableModel::data(const QModelIndex &index, int role) const
{
    if (role == Qt::DisplayRole && index.column() == QuestionColumn::picture) {
        return QSqlTableModel::data(index, role).toByteArray().toBase64();
    }
    return QSqlTableModel::data(index, role);
}

bool QuestionSqlTableModel::setData(const QModelIndex &index,
                                    const QVariant &value, int role)
{
    if (role == Qt::EditRole && index.column() == QuestionColumn::picture) {
        auto picturePath = value.toString();

        auto pictureByteArray = picturePathToByteArray(picturePath);
        return QSqlTableModel::setData(index, pictureByteArray, role);
    }
    return QSqlTableModel::setData(index, value, role);
}

QByteArray
QuestionSqlTableModel::picturePathToByteArray(const QString &picturePath) const
{
    QByteArray picture;
    if (!picturePath.isEmpty()) {
        QPixmap inPixmap;
        if (inPixmap.load(picturePath)) {
            QBuffer inBuffer(&picture);
            inBuffer.open(QIODevice::WriteOnly);
            inPixmap.save(&inBuffer, "PNG");
        }
    }
    return picture;
}
