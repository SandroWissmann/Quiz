#ifndef QUESTIONSQLTABLEMODEL_H
#define QUESTIONSQLTABLEMODEL_H

#include <QSqlTableModel>

class QuestionSqlTableModel : public QSqlTableModel
{
    Q_OBJECT
public:
    explicit QuestionSqlTableModel(QObject *parent = nullptr,
                                   const QSqlDatabase &db = QSqlDatabase());

};

#endif // QUESTIONSQLTABLEMODEL_H

