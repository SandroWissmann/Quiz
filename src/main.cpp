#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QStandardPaths>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDir>
#include <QDebug>
#include <QQuickStyle>

#include "include/questionsqltablemodel.h"
#include "include/questionsqlcolumnnames.h"
#include "include/randomquestionfiltermodel.h"

QString createPath(const QString &database_filename)
{
    QString path{ QStandardPaths::writableLocation(
                     QStandardPaths::StandardLocation::DesktopLocation) };
    path.append(QDir::separator()).append(database_filename);
    return QDir::toNativeSeparators(path);
}

bool createConnection(const QString &database_path)
{
    auto db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(database_path);
    if (!db.open()) {
        qWarning() << QObject::tr("Database Error");
        return false;
    }
    return true;
}

void createTable(const QString &tableName)
{
    QSqlQuery query;
    query.exec("DROP TABLE " + tableName);

    query.exec(
        "CREATE TABLE " + tableName + " ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "question TEXT, "
        "answer1 TEXT, "
        "answer2 TEXT, "
        "answer3 TEXT, "
        "answer4 TEXT, "
        "correct_answer INTEGER, "
        "picture BLOB)");

    if (query.lastError().type() == QSqlError::ErrorType::NoError) {
        qDebug() << "Query OK:"  << query.lastQuery();
        qDebug() << "------";
    }
    else {
        qWarning() << "Query KO:" << query.lastError().text();
        qWarning() << "Query text:" << query.lastQuery();
        qWarning() << "------";
    }
}



int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setOrganizationName("somename");
    app.setOrganizationDomain("somename");

    static constexpr auto database_name = "quiz.db";
    static constexpr auto table_name = "questions";
    auto database_path = createPath(database_name);

    auto existingData = QFile::exists(database_path);

    if (!createConnection(database_path)) {
        return -1;
    }

    if(!existingData) {
        createTable(table_name);
    }

    auto questionSqlTableModel = new QuestionSqlTableModel{};
    questionSqlTableModel->setTable("questions");
    questionSqlTableModel->setSort(QuestionColumn::id, Qt::AscendingOrder);
    questionSqlTableModel->select();

    auto randomQuestionFilterModel = new RandomQuestionFilterModel{};
    randomQuestionFilterModel->setSourceModel(questionSqlTableModel);

    QQuickStyle::setStyle("Universal");

    QQmlApplicationEngine engine;

    auto context = engine.rootContext();
    context->setContextProperty("questionSqlTableModel", questionSqlTableModel);
    context->setContextProperty("randomQuestionFilterModel",
                                randomQuestionFilterModel);


    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
