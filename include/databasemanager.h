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

class QUrl;
class QSqlDatabase;

class QuestionSqlTableModel;
class QuestionsProxyModel;
class RandomQuestionFilterModel;

/*
This class allows changing the questions databases at runtime.

Therefore it holds references to all models connecting to the database with
the questions:

QuestionSqlTableModel:
-> takes the database connection directly as its data source.

QuestionsProxyModel:
-> Uses QuestionSqlTableModel as a source of data. Its used as an adapter
to map the Qt Widget table access (access by column numbers) to the
QML Table acces scheme (Access by user defined roles).

RandomQuestionFilterModel:
-> Uses QuestionsProxyModel as its source of data and filters to only provide
n random questions.

So in short the data is forwarded like this:
Database -> QuestionSqlTableModel -> QuestionsProxyModel ->
RandomQuestionFilterModel

The current database can be changed with the function
changeDatabaseConnection(). Since QuestionSqlTableModel database cannot be
changed at runtime the model is replaced with a new instance. Then
QuestionsProxyModel changes it data source to the new instance of
QuestionsProxyModel.
*/

class DatabaseManager : public QObject {
    Q_OBJECT
public:
    explicit DatabaseManager(QObject *parent = nullptr);

    /*
    Takes a path and creates a new database connection to it.
    If the path does not exist a new database with the correct questions table
    is created.
    If a database exists in path the database is validated if it is a correct
    database only containing a single questions table.

    On success true is returned. If there should be an error the old connection
    is keept and false is returned.

    For details of the error the method lastError() can be called
    */
    Q_INVOKABLE bool changeDatabaseConnection(const QUrl &databasePath);

    /*
    Reports the last occured error.
    Possible errors:
    - Database could not be opened
    - Creating question table failed. Error: "lastError from DB"
    - Database does not contain valid questions table
    - Questions table has invalid count of columns
    - Column x does not exists in questions table
    - Column x is not of type y in questions table
    */
    Q_INVOKABLE QString lastError() const;

    /*
    Returns the models which are designed to be exposed to QML.
    */
    QuestionsProxyModel *questionsProxyModel() const;
    RandomQuestionFilterModel *randomQuestionFilterModel() const;

private:
    QString mCurrentConnectionName;
    QString mLastError;
    bool databaseExists(const QUrl &dbPath) const;
    bool createQuestionTable(QSqlDatabase &db);
    QString getNewConnectionName() const;
    void validateDatabase(const QSqlDatabase &db);

    QuestionSqlTableModel *mQuestionsSqlTableModel{nullptr};
    QuestionsProxyModel *mQuestionsProxModel{nullptr};
    RandomQuestionFilterModel *mRandomQuestionFilterModel{nullptr};
};

#endif // DATABASEMANAGER_H
