/* Quiz
 * Copyright (C) 2020  Sandro Wißmann
 *
 * Quiz is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Quiz is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Quiz If not, see <http://www.gnu.org/licenses/>.
 *
 * Web-Site: https://github.com/SandroWissmann/Quiz
 */
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
    if (!select()) {
        qDebug() << "QuestionSqlTableModel: Select table questions failed";
    }
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

bool QuestionSqlTableModel::removeRows(int row, int count,
                                       const QModelIndex &parent)
{
    auto result = QSqlTableModel::removeRows(row, count, parent);
    if (result) {
        select(); // row is not deleted from sql database until select is called
    }
    return result;
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
