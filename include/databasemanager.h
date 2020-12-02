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
#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QUrl>

class QuestionSqlTableModel;
class QuestionsProxyModel;
class RandomQuestionFilterModel;

class DatabaseManager : public QObject {
    Q_OBJECT
public:
    explicit DatabaseManager(QObject *parent = nullptr);

    Q_INVOKABLE void changeDatabaseConnection(const QUrl &databasePath);

    QuestionsProxyModel *questionsProxyModel() const;
    RandomQuestionFilterModel *randomQuestionFilterModel() const;

private:
    QString mCurrentConnectionName;
    bool databaseExists(const QUrl &dbPath) const;
    bool createQuestionTable(QSqlDatabase &db);
    QString getNewConnectionName() const;

    QuestionSqlTableModel *mQuestionsSqlTableModel{nullptr};
    QuestionsProxyModel *mQuestionsProxModel{nullptr};
    RandomQuestionFilterModel *mRandomQuestionFilterModel{nullptr};
};

#endif // DATABASEMANAGER_H
