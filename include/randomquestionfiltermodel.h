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
#ifndef RANDOMQUESTIONFILTERMODEL_H
#define RANDOMQUESTIONFILTERMODEL_H

#include <QSortFilterProxyModel>
#include <QVector>

/*
This class should be installed on a source model with the following columns:
    0 - id  INTEGER
    1 - askedQuestion TEXT
    2 - answer1 TEXT
    3 - answer2 TEXT
    4 - answer3 TEXT
    5 - answer4 TEXT
    6 - correctAnswer INTEGER
    7 - picture BLOB
The function generateRandomQuestions(int count) selects n random rows from the
source model and forwards them to RandomQuestionFilterModel.
Then from QML only the random selected entries are visible.
*/
class RandomQuestionFilterModel : public QSortFilterProxyModel {
    Q_OBJECT

    enum questionRoles {
        idRole = Qt::UserRole + 1,
        askedQuestionRole,
        answer1Role,
        answer2Role,
        answer3Role,
        answer4Role,
        correctAnswerRole,
        pictureRole
    };

public:
    RandomQuestionFilterModel(QObject *parent = nullptr);

    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role) const override;

    /*
    Resets the model to select count new random questions from the source model
    */
    Q_INVOKABLE void generateRandomQuestions(int count);

protected:
    bool filterAcceptsRow(int source_row,
                          const QModelIndex &source_parent) const override;

private:
    QVector<int> mAcceptedRows;
};

#endif // RANDOMQUESTIONFILTERMODEL_H
