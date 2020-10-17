#ifndef QUESTIONSQLTABLEMODEL_H
#define QUESTIONSQLTABLEMODEL_H

#include <QSqlTableModel>

class QuestionSqlTableModel : public QSqlTableModel
{
    Q_OBJECT

    enum questionRoles {
        idRole = Qt::UserRole + 1,
        askedQuestionRole,
        answer1Role,
        answer2Role,
        answer3Role,
        answer4Role,
        correctAnswerRole,
        pictureRole
    };

public:
    explicit QuestionSqlTableModel(QObject *parent = nullptr,
                                   const QSqlDatabase &db = QSqlDatabase());

    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE QVariant data(const QModelIndex &index, int role) const override;

    Q_INVOKABLE bool addNewEntry(const QString& askedQuestion,
        const QString& answer1,
        const QString& answer2,
        const QString& answer3,
        const QString& answer4,
        int correctAnswer,
        const QString& picturePath);

private:
    int schmalz = 5;
};

#endif // QUESTIONSQLTABLEMODEL_H

