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
#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>

class QSqlDatabase;

class Database : public QObject {
    Q_OBJECT
public:
    explicit Database(QObject *parent = nullptr);

    /*
    Open an existing Database. Does not succeed if there is already a
    database opened. Use closeDatabase() before opening annother database.
    Does not succed if path does not point to an existing database
    */
    Q_INVOKABLE bool open(const QString &databaseAbsolutePath);

    /*
    Creates a new Database. Does not succeed if there is already a
    database opened. Use closeDatabase() before opening annother database.
    Does not succed if there exisst already a database with that name.
    */
    Q_INVOKABLE bool create(const QString &databaseAbsolutePath);

    Q_INVOKABLE bool close();

    /*
    Checks if currently open database is a valid database with a quiz table.
    Returns false if no database is open or no question table exists.
    */
    Q_INVOKABLE bool hasQuestionTable();

    /* Returns last error of database. Empty if not error occurs */
    QString lastError() const;

private:
    /*
    Checks if database exists at path.
    */
    bool exists(const QString &databaseAbsolutePath) const;

    /*
    Create a table in the currently open database to hold the question data.
    Returns false if table already exists.
    Returns false if no database is opened.
    */
    bool createQuestionTable();

    QSqlDatabase mDb;
};

#endif // DATABASECONNECTIONMANAGER_H
