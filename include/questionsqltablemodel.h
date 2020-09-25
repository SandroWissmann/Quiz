#ifndef QUESTIONSQLTABLEMODEL_H
#define QUESTIONSQLTABLEMODEL_H

#include "question.h"

#include <QSqlTableModel>
#include <QQmlListProperty>


class QuestionSqlTableModel : public QSqlTableModel
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<Question> randomQuestions
               READ getRandomQuestions
               NOTIFY randomQuestionsChanged)
public:
    explicit QuestionSqlTableModel(QObject *parent = nullptr,
                                   const QSqlDatabase &db = QSqlDatabase());

    Q_INVOKABLE QVariant data(const QModelIndex &index, int role) const override;


    Q_INVOKABLE bool addNewEntry(const QString& askedQuestion,
        const QString& answer1,
        const QString& answer2,
        const QString& answer3,
        const QString& answer4,
        int correctAnswer,
        const QString& picturePath);

    Q_INVOKABLE void generateNewRandomQuestions(int count);

    QQmlListProperty <Question> getRandomQuestions();

signals:
    void randomQuestionsChanged();

private:
    void appendRandomQuestion(Question *question);
    int randomQuestionsCount() const;
    Question* randomQuestionAt(int index) const;
    void randomQuestionsClear();

    static void appendRandomQuestion(
            QQmlListProperty<Question>* list, Question *question);
    static int randomQuestionsCount(QQmlListProperty<Question>* list);
    static Question* randomQuestionAt(
            QQmlListProperty<Question>* list, int index);
    static void randomQuestionsClear(QQmlListProperty<Question>* list);

    QVector<Question*> mRandomQuestions;
};

#endif // QUESTIONSQLTABLEMODEL_H

