#include "../include/databasemanager.h"

#include <QDebug>
#include <QSqlQuery>

DatabaseManager::DatabaseManager(QObject *parent)
    : QObject(parent), mDb{QSqlDatabase::addDatabase("QSQLITE")}
{
}

bool DatabaseManager::openDatabase(const QString &databaseAbsolutePath)
{
    mDb.setDatabaseName(databaseAbsolutePath);
    return mDb.open();
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

QSqlError DatabaseManager::lastError() const
{
    return mDb.lastError();
}
