#ifndef QUESTION_H
#define QUESTION_H

#include <QString>
#include <QObject>

class Question : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ getId CONSTANT)
    Q_PROPERTY(QString askedQuestion READ getAskedQuestion CONSTANT)
    Q_PROPERTY(QString answer1 READ getAnswer1 CONSTANT)
    Q_PROPERTY(QString answer2 READ getAnswer2 CONSTANT)
    Q_PROPERTY(QString answer3 READ getAnswer3 CONSTANT)
    Q_PROPERTY(QString answer4 READ getAnswer4 CONSTANT)
    Q_PROPERTY(int correctAnswer READ getCorrectAnswer CONSTANT)
    Q_PROPERTY(QString picture READ getPicture CONSTANT)
public:
    enum class Correct{
        Answer1 = 1,
        Answer2 = 2,
        Answer3 = 3,
        Answer4 = 4
    };

    Question() = default;

    Question(int id,
             QString askedQuestion,
             QString answer1,
             QString answer2,
             QString answer3,
             QString answer4,
             Correct correctAnswer,
             QString picture = QString{});

    int getId() const;
    QString getAskedQuestion() const;
    QString getAnswer1() const;
    QString getAnswer2() const;
    QString getAnswer3() const;
    QString getAnswer4() const;
    int getCorrectAnswer() const;
    QString getPicture() const;

private:
    int mId;
    QString mAskedQuestion;
    QString mAnswer1;
    QString mAnswer2;
    QString mAnswer3;
    QString mAnswer4;
    Correct mCorrectAnswer;
    QString mPicture;
};

#endif // QUESTION_H
