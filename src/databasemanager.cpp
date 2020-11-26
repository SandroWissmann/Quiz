#include "../include/databasemanager.h"

#include <QDebug>
#include <QFile>
#include <QSqlQuery>

DatabaseManager::DatabaseManager(QObject *parent)
    : QObject(parent), mDb{QSqlDatabase::addDatabase("QSQLITE")}
{
}

bool DatabaseManager::databaseExists(const QString &databaseAbsolutePath) const
{
    return QFile::exists(databaseAbsolutePath);
}

bool DatabaseManager::openDatabase(const QString &databaseAbsolutePath)
{
    if (mDb.isOpen()) {
        return false;
    }
    mDb.setDatabaseName(databaseAbsolutePath);
    return mDb.open();
}

bool DatabaseManager::closeDatabase()
{
    mDb.close();
    return !mDb.isOpen();
}

bool DatabaseManager::createQuestionTable()
{
    const QString tableName = "questions";

    QSqlQuery query;
    query.exec("DROP TABLE " + tableName);

    query.exec("CREATE TABLE " + tableName +
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

QString DatabaseManager::lastError() const
{
    return mDb.lastError().text();
}
