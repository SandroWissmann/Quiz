#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QUrl>

class QuestionSqlTableModel;
class QuestionsProxyModel;
class RandomQuestionFilterModel;

class DatabaseManager : public QObject {
    Q_OBJECT
public:
    explicit DatabaseManager(QObject *parent = nullptr);

    Q_INVOKABLE void connectToOtherDatabase(const QUrl &databasePath);

    QuestionsProxyModel *questionsProxyModel() const;
    RandomQuestionFilterModel *randomQuestionFilterModel() const;

private:
    QSqlDatabase openDatabaseConnection(const QUrl &dbPath);
    bool databaseExists(const QUrl &dbPath) const;
    bool createQuestionTable();

    QuestionSqlTableModel *mQuestionsSqlTableModel{nullptr};
    QuestionsProxyModel *mQuestionsProxModel{nullptr};
    RandomQuestionFilterModel *mRandomQuestionFilterModel{nullptr};
};

#endif // DATABASEMANAGER_H
