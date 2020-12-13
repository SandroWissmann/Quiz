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
#ifndef QUESTIONSPROXYMODEL_H
#define QUESTIONSPROXYMODEL_H

#include <QIdentityProxyModel>
#include <QObject>

/*
This class maps QML of access by role name to access by column in
QSqlTableModel.
The source model must provide a table with the defined columns:
        0 - id
        1 - askedQuestion
        2 - answer1
        3 - answer2
        4 - answer3
        5 - answer4
        6 - correctAnswer
        7 - picture
*/
class QuestionsProxyModel : public QIdentityProxyModel {
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
    QuestionsProxyModel(QObject *parent = nullptr);

    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE QVariant data(const QModelIndex &index,
                              int role = Qt::DisplayRole) const override;

    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Q_INVOKABLE bool addNewEntry(const QString &askedQuestion,
                                 const QString &answer1, const QString &answer2,
                                 const QString &answer3, const QString &answer4,
                                 int correctAnswer, const QString &picturePath);

    Q_INVOKABLE void edit(int row, const QVariant &value, const QString &role);

    Q_INVOKABLE bool removeEntry(int row);

private:
    QModelIndex mapIndex(const QModelIndex &index, int role) const;

    bool saveIfIsSQLDatabase();
};

#endif // QUESTIONSPROXYQML_H
