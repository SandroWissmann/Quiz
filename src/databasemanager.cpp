#include "../include/databasemanager.h"

#include <QDebug>
#include <QFile>
#include <QSqlQuery>

DatabaseManager::DatabaseManager(QObject *parent)
    : QObject(parent), mDb{QSqlDatabase::addDatabase("QSQLITE")}
{
}

bool DatabaseManager::openDatabase(const QString &databaseAbsolutePath)
{
    if (mDb.isOpen()) {
        return false;
    }
    mDb.setDatabaseName(databaseAbsolutePath);
    return mDb.open();
}

bool DatabaseManager::createDatabase(const QString &databaseAbsolutePath)
{
    if (mDb.isOpen()) {
        return false;
    }
    if (databaseExists(databaseAbsolutePath)) {
        return false;
    }
    mDb.setDatabaseName(databaseAbsolutePath);
    if (!mDb.open()) {
    }
    return createQuestionTable();
}

bool DatabaseManager::closeDatabase()
{
    mDb.close();
    return !mDb.isOpen();
}

bool DatabaseManager::createQuestionTable()
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

bool DatabaseManager::hasQuestionTable()
{
    if (!mDb.isOpen()) {
        return false;
    }
    const QString questionTableName = "questions";
    return mDb.tables().contains(questionTableName);
}

QString DatabaseManager::lastError() const
{
    if (!mDb.isOpen()) {
        return {};
    }
    return mDb.lastError().text();
}

bool DatabaseManager::databaseExists(const QString &databaseAbsolutePath) const
{
    return QFile::exists(databaseAbsolutePath);
}
