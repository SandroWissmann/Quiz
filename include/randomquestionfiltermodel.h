#ifndef RANDOMQUESTIONFILTERMODEL_H
#define RANDOMQUESTIONFILTERMODEL_H

#include <QSortFilterProxyModel>
#include <QVector>

class RandomQuestionFilterModel : public QSortFilterProxyModel
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
    RandomQuestionFilterModel(QObject *parent = nullptr);

    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role) const override;

    Q_INVOKABLE void generateRandomQuestions(int count);
protected:
    bool filterAcceptsRow(int source_row,
                          const QModelIndex &source_parent) const override;
private:
    QVector<int> mAcceptedRows;
};

#endif // RANDOMQUESTIONFILTERMODEL_H
