#ifndef QUESTIONSPROXYMODEL_H
#define QUESTIONSPROXYMODEL_H

#include <QObject>
#include <QIdentityProxyModel>

class QuestionsProxyModel : public QIdentityProxyModel
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
    QuestionsProxyModel(QObject* parent = nullptr);

    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE QVariant data(const QModelIndex &index,
                              int role = Qt::DisplayRole) const override;

    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Q_INVOKABLE bool addNewEntry(const QString& askedQuestion,
        const QString& answer1,
        const QString& answer2,
        const QString& answer3,
        const QString& answer4,
        int correctAnswer,
        const QString& picturePath);

    Q_INVOKABLE void edit(int row, const QVariant &value, const QString &role);

private:
    QModelIndex mapIndex(const QModelIndex &index, int role) const;

    void saveIfIsSQLDatabase();
};

#endif // QUESTIONSPROXYQML_H
