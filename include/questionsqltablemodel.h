#ifndef QUESTIONSQLTABLEMODEL_H
#define QUESTIONSQLTABLEMODEL_H

#include <QSqlTableModel>

class QuestionSqlTableModel : public QSqlTableModel
{
    Q_OBJECT
public:
    explicit QuestionSqlTableModel(QObject *parent = nullptr,
                                   const QSqlDatabase &db = QSqlDatabase());

    QVariant data(const QModelIndex &index, int role) const;

    bool setData(const QModelIndex &index, const QVariant &value, int role);
};

#endif // QUESTIONSQLTABLEMODEL_H

