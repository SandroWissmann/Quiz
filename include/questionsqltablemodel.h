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
#ifndef QUESTIONSQLTABLEMODEL_H
#define QUESTIONSQLTABLEMODEL_H

#include <QSqlTableModel>

/*
This class contains a model which connects to an sql database which whould
contain:

A table "questions" with the columns / types:
    0 - id  INTEGER
    1 - askedQuestion TEXT
    2 - answer1 TEXT
    3 - answer2 TEXT
    4 - answer3 TEXT
    5 - answer4 TEXT
    6 - correctAnswer INTEGER
    7 - picture BLOB
*/

class QuestionSqlTableModel : public QSqlTableModel {
    Q_OBJECT
public:
    explicit QuestionSqlTableModel(QObject *parent = nullptr,
                                   const QSqlDatabase &db = QSqlDatabase());

    QVariant data(const QModelIndex &index, int role) const override;

    bool setData(const QModelIndex &index, const QVariant &value,
                 int role) override;

    bool removeRows(int row, int count, const QModelIndex &parent) override;

private:
    QByteArray picturePathToByteArray(const QString &picturePath) const;
};

#endif // QUESTIONSQLTABLEMODEL_H
