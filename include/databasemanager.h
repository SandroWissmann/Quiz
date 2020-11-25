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

    bool openDatabase(const QString &databaseAbsolutePath);

    bool createQuestionTable();

    QSqlError lastError() const;

private:
    QSqlDatabase mDb;
};

#endif // DATABASECONNECTIONMANAGER_H
