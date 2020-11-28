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
#include "../include/database.h"

#include <QDebug>
#include <QFile>
#include <QSqlQuery>

Database::Database(QObject *parent)
    : QObject(parent), mDb{QSqlDatabase::addDatabase("QSQLITE")}
{
}

bool Database::open(const QString &databaseAbsolutePath)
{
    if (mDb.isOpen()) {
        return false;
    }
    if (!exists(databaseAbsolutePath)) {
        return false;
    }
    mDb.setDatabaseName(databaseAbsolutePath);
    return mDb.open();
}

bool Database::create(const QString &databaseAbsolutePath)
{
    if (mDb.isOpen()) {
        return false;
    }
    if (exists(databaseAbsolutePath)) {
        return false;
    }
    mDb.setDatabaseName(databaseAbsolutePath);
    if (!mDb.open()) {
    }
    return createQuestionTable();
}

bool Database::close()
{
    mDb.close();
    return !mDb.isOpen();
}

bool Database::createQuestionTable()
{
    if (!mDb.isOpen()) {
        return false;
    }
    const QString questionTableName = "questions";

    QSqlQuery query;
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

bool Database::hasQuestionTable()
{
    if (!mDb.isOpen()) {
        return false;
    }
    const QString questionTableName = "questions";
    return mDb.tables().contains(questionTableName);
}

QString Database::lastError() const
{
    if (!mDb.isOpen()) {
        return {};
    }
    return mDb.lastError().text();
}

bool Database::exists(const QString &databaseAbsolutePath) const
{
    return QFile::exists(databaseAbsolutePath);
}
