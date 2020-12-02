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
#include <QSqlDriver>
#include <QSqlError>
#include <QSqlField>
#include <QSqlQuery>
#include <QSqlRecord>

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

bool DatabaseManager::changeDatabaseConnection(const QUrl &databasePath)
{
    auto connectionName = getNewConnectionName();

    bool dbExists = databaseExists(databasePath);
    auto db = QSqlDatabase::addDatabase("QSQLITE", connectionName);

    db.setDatabaseName(databasePath.toLocalFile());
    if (!db.open()) {
        mLastError = tr("Database could not be opened");
    }
    if (!dbExists) {
        if (!createQuestionTable(db)) {
            mLastError = tr("Creating question table failed. Error: %1")
                             .arg(db.lastError().text());
        }
    }
    else {
        validateDatabase(db);
    }

    if (!mLastError.isEmpty()) {
        QSqlDatabase::removeDatabase(connectionName);
        return false;
    }

    auto newQuestionsSqlTableModel = new QuestionSqlTableModel{this, db};
    mQuestionsProxModel->setSourceModel(newQuestionsSqlTableModel);
    delete mQuestionsSqlTableModel;
    mQuestionsSqlTableModel = newQuestionsSqlTableModel;

    if (QSqlDatabase::contains(mCurrentConnectionName)) {
        QSqlDatabase::removeDatabase(mCurrentConnectionName);
    }
    mCurrentConnectionName = connectionName;
    mLastError = "";
    return true;
}

QString DatabaseManager::lastError() const
{
    return mLastError;
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

void DatabaseManager::validateDatabase(const QSqlDatabase &db)
{
    auto tables = db.tables();
    if (tables.size() != 1 && tables[0] != "questions") {
        mLastError = tr("Database does not contain valid questions table");
        return;
    }

    auto driver = db.driver();
    auto record = driver->record("questions");

    if (record.count() != 8) {
        mLastError = tr("Questions table has invalid count");
        return;
    }

    if (record.field(0).name() != "id") {
        mLastError = tr("Column id does not exists in questions table");
        return;
    }
    if (record.field(1).name() != "question") {
        mLastError = tr("Column question does not exists in questions table");
        return;
    }
    if (record.field(2).name() != "answer1") {
        mLastError = tr("Column answer1 does not exists in questions table");
        return;
    }
    if (record.field(3).name() != "answer2") {
        mLastError = tr("Column answer2 does not exists in questions table");
        return;
    }
    if (record.field(4).name() != "answer3") {
        mLastError = tr("Column answer3 does not exists in questions table");
        return;
    }
    if (record.field(5).name() != "answer4") {
        mLastError = tr("Column answer4 does not exists in questions table");
        return;
    }
    if (record.field(6).name() != "correct_answer") {
        mLastError =
            tr("Column correct_answer does not exists in questions table");
        return;
    }
    if (record.field(7).name() != "picture") {
        mLastError = tr("Column picture does not exists in questions table");
        return;
    }

    if (record.field(0).type() != QVariant::Type::Int) {
        mLastError = tr("Column id is not of type int in questions table");
        return;
    }
    if (record.field(1).type() != QVariant::Type::String) {
        mLastError =
            tr("Column question is not of type string in questions table");
        return;
    }
    if (record.field(2).type() != QVariant::Type::String) {
        mLastError =
            tr("Column answer1 is not of type string in questions table");
        return;
    }
    if (record.field(3).type() != QVariant::Type::String) {
        mLastError =
            tr("Column answer2 is not of type string in questions table");
        return;
    }
    if (record.field(4).type() != QVariant::Type::String) {
        mLastError =
            tr("Column answer3 is not of type string in questions table");
        return;
    }
    if (record.field(5).type() != QVariant::Type::String) {
        mLastError =
            tr("Column answer4 is not of type string in questions table");
        return;
    }
    if (record.field(6).type() != QVariant::Type::Int) {
        mLastError =
            tr("Column correct_answer is not of type int in questions table");
        return;
    }
    if (record.field(7).type() != QVariant::Type::ByteArray) {
        mLastError =
            tr("Column picture is not of type byteArray in questions table");
        return;
    }
}
