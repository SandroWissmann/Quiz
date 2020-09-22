#ifndef QUESTIONSQLTABLEMODEL_H
#define QUESTIONSQLTABLEMODEL_H

#include <QSqlTableModel>

class QuestionSqlTableModel : public QSqlTableModel
{
    Q_OBJECT
public:
    explicit QuestionSqlTableModel(QObject *parent = nullptr,
                                   const QSqlDatabase &db = QSqlDatabase());

    Q_INVOKABLE QVariant data(const QModelIndex &index, int role) const override;
};

#endif // QUESTIONSQLTABLEMODEL_H

