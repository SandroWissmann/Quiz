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
