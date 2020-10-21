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

    Q_INVOKABLE QVariant headerData(int section, Qt::Orientation orientation,
                                    int role) const override;

    Q_INVOKABLE QVariant data(const QModelIndex &index, int role) const override;

    Q_INVOKABLE bool addNewEntry(const QString& askedQuestion,
        const QString& answer1,
        const QString& answer2,
        const QString& answer3,
        const QString& answer4,
        int correctAnswer,
        const QString& picturePath);
private:
    QModelIndex mapIndex(const QModelIndex &index, int role) const;
};

#endif // QUESTIONSPROXYQML_H
