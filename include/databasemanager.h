#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>

class QSqlDatabase;

class DatabaseManager : public QObject {
    Q_OBJECT
public:
    explicit DatabaseManager(QObject *parent = nullptr);

    /*
    Checks if database exists at path.
    */
    bool databaseExists(const QString &databaseAbsolutePath) const;

    /*
    Open an existing Database or if not exists create a new one.
    Returns true on success. Does not succeed if there is already a
    database opened. Use closeDatabase() before opening annother database
    */
    bool openDatabase(const QString &databaseAbsolutePath);

    bool closeDatabase();

    bool createQuestionTable();

    /* Returns last error of database. Empty if not error occurs */
    QString lastError() const;

private:
    QSqlDatabase mDb;
};

#endif // DATABASECONNECTIONMANAGER_H
