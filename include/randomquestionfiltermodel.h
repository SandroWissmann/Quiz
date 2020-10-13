#ifndef RANDOMQUESTIONFILTERMODEL_H
#define RANDOMQUESTIONFILTERMODEL_H

#include <QSortFilterProxyModel>
#include <QVector>

class RandomQuestionFilterModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    RandomQuestionFilterModel(QObject *parent = nullptr);

    Q_INVOKABLE void generateRandomQuestions(int count);
protected:
    bool filterAcceptsRow(int source_row,
                          const QModelIndex &source_parent) const override;
private:
    QVector<int> mAcceptedRows;
};

#endif // RANDOMQUESTIONFILTERMODEL_H
