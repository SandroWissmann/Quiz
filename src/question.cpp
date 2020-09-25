#include "../include/question.h"

Question::Question(int id, QString question,
                   QString answer1,
                   QString answer2,
                   QString answer3,
                   QString answer4,
                   Question::Correct correctAnswer,
                   QByteArray picture)
    : mId{id},
      mAskedQuestion{std::move( question )},
      mAnswer1{std::move( answer1 )},
      mAnswer2{std::move( answer2 )},
      mAnswer3{std::move( answer3 )},
      mAnswer4{std::move( answer4 )},
      mCorrectAnswer{ correctAnswer},
      mPicture{std::move( picture )}
{
}

int Question::getId() const
{
    return mId;
}

QString Question::getAskedQuestion() const
{
    return mAskedQuestion;
}

QString Question::getAnswer1() const
{
    return mAnswer1;
}

QString Question::getAnswer2() const
{
    return mAnswer2;
}

QString Question::getAnswer3() const
{
    return mAnswer3;
}

QString Question::getAnswer4() const
{
    return mAnswer4;
}

int Question::getCorrectAnswer() const
{
    return static_cast<int>(mCorrectAnswer);
}

QByteArray Question::getPicture() const
{
    return mPicture;
}

