#ifndef QUESTION_H
#define QUESTION_H

#include <QString>
#include <QObject>

class Question : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ getId)
    Q_PROPERTY(QString askedQuestion READ getAskedQuestion)
    Q_PROPERTY(QString answer1 READ getAnswer1)
    Q_PROPERTY(QString answer2 READ getAnswer2)
    Q_PROPERTY(QString answer3 READ getAnswer3)
    Q_PROPERTY(QString answer4 READ getAnswer4)
    Q_PROPERTY(int correctAnswer READ getCorrectAnswer)
    Q_PROPERTY(QByteArray picture READ getPicture)
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
             QByteArray picture = QByteArray{});

    int getId() const;
    QString getAskedQuestion() const;
    QString getAnswer1() const;
    QString getAnswer2() const;
    QString getAnswer3() const;
    QString getAnswer4() const;
    int getCorrectAnswer() const;
    QByteArray getPicture() const;

private:
    int mId;
    QString mAskedQuestion;
    QString mAnswer1;
    QString mAnswer2;
    QString mAnswer3;
    QString mAnswer4;
    Correct mCorrectAnswer;
    QByteArray mPicture;
};

#endif // QUESTION_H
