#include "../include/databasemanager.h"

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

void DatabaseManager::connectToOtherDatabase(const QUrl &databasePath)
{
    qDebug() << databasePath.toLocalFile();
    auto db = openDatabaseConnection(databasePath);

    qDebug() << db.lastError().text();

    auto newQuestionsSqlTableModel = new QuestionSqlTableModel{this, db};
    qDebug() << newQuestionsSqlTableModel->rowCount();
    mQuestionsProxModel->setSourceModel(newQuestionsSqlTableModel);
    mQuestionsSqlTableModel = newQuestionsSqlTableModel;
}

QuestionsProxyModel *DatabaseManager::questionsProxyModel() const
{
    qDebug() << mQuestionsProxModel->rowCount();
    return mQuestionsProxModel;
}

RandomQuestionFilterModel *DatabaseManager::randomQuestionFilterModel() const
{
    return mRandomQuestionFilterModel;
}

QSqlDatabase DatabaseManager::openDatabaseConnection(const QUrl &dbPath)
{
    constexpr auto connectionName = "QuestionsConnnection";

    if (QSqlDatabase::contains(connectionName)) {
        QSqlDatabase::removeDatabase(connectionName);
    }

    auto db = QSqlDatabase::addDatabase("QSQLITE", connectionName);
    db.setDatabaseName(dbPath.toLocalFile());
    db.open();
    if (!databaseExists(dbPath)) {
        createQuestionTable();
    }
    return db;
}

bool DatabaseManager::databaseExists(const QUrl &dbPath) const
{
    return QFile::exists(dbPath.toLocalFile());
}

bool DatabaseManager::createQuestionTable()
{
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
