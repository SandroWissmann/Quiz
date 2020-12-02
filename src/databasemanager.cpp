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
#include "../include/databasemanager.h"

#include <QDateTime>
#include <QFile>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>

#include <QDebug>

#include "../include/questionsproxymodel.h"
#include "../include/questionsqltablemodel.h"
#include "../include/randomquestionfiltermodel.h"

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent)
{
    mQuestionsProxModel = new QuestionsProxyModel{this};
    mRandomQuestionFilterModel = new RandomQuestionFilterModel{this};
    mRandomQuestionFilterModel->setSourceModel(mQuestionsProxModel);
}

void DatabaseManager::changeDatabaseConnection(const QUrl &databasePath)
{
    auto connectionName = getNewConnectionName();

    bool dbExists = databaseExists(databasePath);
    auto db = QSqlDatabase::addDatabase("QSQLITE", connectionName);

    db.setDatabaseName(databasePath.toLocalFile());
    db.open();
    if (!dbExists) {
        if (!createQuestionTable(db)) {
            qDebug() << "Creating question table failed";
            qDebug() << db.lastError().text();
        }
    }

    auto newQuestionsSqlTableModel = new QuestionSqlTableModel{this, db};
    mQuestionsProxModel->setSourceModel(newQuestionsSqlTableModel);
    delete mQuestionsSqlTableModel;
    mQuestionsSqlTableModel = newQuestionsSqlTableModel;

    if (QSqlDatabase::contains(mCurrentConnectionName)) {
        QSqlDatabase::removeDatabase(mCurrentConnectionName);
    }
    mCurrentConnectionName = connectionName;
}

QuestionsProxyModel *DatabaseManager::questionsProxyModel() const
{
    return mQuestionsProxModel;
}

RandomQuestionFilterModel *DatabaseManager::randomQuestionFilterModel() const
{
    return mRandomQuestionFilterModel;
}

bool DatabaseManager::databaseExists(const QUrl &dbPath) const
{
    return QFile::exists(dbPath.toLocalFile());
}

bool DatabaseManager::createQuestionTable(QSqlDatabase &db)
{
    const QString questionTableName = "questions";

    QSqlQuery query{db};
    query.exec("CREATE TABLE " + questionTableName +
               " ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT, "
               "question TEXT, "
               "answer1 TEXT, "
               "answer2 TEXT, "
               "answer3 TEXT, "
               "answer4 TEXT, "
               "correct_answer INTEGER, "
               "picture BLOB)");

    return query.lastError().type() == QSqlError::ErrorType::NoError;
}

QString DatabaseManager::getNewConnectionName() const
{
    auto dateTime = QDateTime::currentDateTime();
    return "QuestionConnection" + dateTime.toString("yyyy.MM.dd.hh:mm.ss.zzz");
}
