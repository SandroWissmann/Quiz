#include "questionsqltablemodel.h"

#include "questionsqlcolumnnames.h"

#include <QPixmap>

QuestionSqlTableModel::QuestionSqlTableModel(
        QObject *parent, const QSqlDatabase &db)
    :QSqlTableModel{parent, db}
{
}

QVariant QuestionSqlTableModel::data(const QModelIndex &index, int role) const
{
    if (role == Qt::BackgroundRole) {
        static const auto correctAnswerColor = QColor{ 153, 255, 204 };
        static const auto wrongAnswerColor = QColor{ 255, 153, 153 };
        static const auto questionColor = QColor{ 153, 204, 255 };

        if(index.column() == QuestionColumn::askedQuestion) {
            return questionColor;
        }

        auto correctAnswer = index.siblingAtColumn(
                    QuestionColumn::correct_answer).data().toInt();


        if(index.column() == QuestionColumn::answer1) {
            if(correctAnswer == 1) {
                return correctAnswerColor;
            }
            return wrongAnswerColor;
        }
        if(index.column() == QuestionColumn::answer2) {
            if(correctAnswer == 2) {
                return correctAnswerColor;
            }
            return wrongAnswerColor;
        }
        if(index.column() == QuestionColumn::answer3) {
            if(correctAnswer == 3) {
                return correctAnswerColor;
            }
            return wrongAnswerColor;
        }
        if(index.column() == QuestionColumn::answer4) {
            if(correctAnswer == 4) {
                return correctAnswerColor;
            }
            return wrongAnswerColor;
        }
    }

    if (index.column() == QuestionColumn::picture) {
        auto imgFile = QSqlTableModel::data(
                    index, Qt::DisplayRole).toByteArray();

        if (role == Qt::DisplayRole) {
            return QString{};
        }

        QPixmap pixmap;
        if(!imgFile.isNull()) {
            pixmap.loadFromData(imgFile);
            pixmap = pixmap.scaled(
                100, 100, Qt::IgnoreAspectRatio, Qt::FastTransformation);
        }

        if (role == Qt::DecorationRole) {
            return pixmap;
        }
        if (role == Qt::SizeHintRole) {
            return pixmap.size();
        }
    }
    return QSqlTableModel::data( index, role );
}
