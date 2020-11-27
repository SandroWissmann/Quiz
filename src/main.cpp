/* Quiz
 * Copyright (C) 2020  Sandro Wißmann
 *
 * Quiz is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Quiz is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Quiz If not, see <http://www.gnu.org/licenses/>.
 *
 * Web-Site: https://github.com/SandroWissmann/Quiz
 */
#include <QDebug>
#include <QDir>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QStandardPaths>

#include "include/database.h"
#include "include/languageselector.h"
#include "include/questionsproxymodel.h"
#include "include/questionsqlcolumnnames.h"
#include "include/questionsqltablemodel.h"
#include "include/randomquestionfiltermodel.h"

QString createPath(const QString &database_filename)
{
    QString path{QStandardPaths::writableLocation(
        QStandardPaths::StandardLocation::DesktopLocation)};
    path.append(QDir::separator()).append(database_filename);
    return QDir::toNativeSeparators(path);
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setOrganizationName("Sandro Wißmann");
    app.setOrganizationDomain("Sandro Wißmann Private");

    static constexpr auto database_name = "quiz.db";
    auto database_path = createPath(database_name);

    qDebug() << database_path;

    Database database;

    if (!database.open(database_path)) {
        if (!database.lastError().isEmpty()) {
            qDebug() << database.lastError();
            return -1;
        }
        if (!database.create(database_path)) {
            qDebug() << database.lastError();
            return -1;
        }
    }

    auto questionSqlTableModel = new QuestionSqlTableModel{};

    auto questionsProxyModel = new QuestionsProxyModel{};
    questionsProxyModel->setSourceModel(questionSqlTableModel);

    auto randomQuestionFilterModel = new RandomQuestionFilterModel{};
    randomQuestionFilterModel->setSourceModel(questionsProxyModel);

    QQuickStyle::setStyle("Material");

    QScopedPointer<LanguageSelector> languageSelector(new LanguageSelector);

    QQmlApplicationEngine engine;

    auto context = engine.rootContext();
    context->setContextProperty("questionsProxyModel", questionsProxyModel);
    context->setContextProperty("randomQuestionFilterModel",
                                randomQuestionFilterModel);

    qmlRegisterSingletonInstance<LanguageSelector>(
        "LanguageSelectors", 1, 0, "LanguageSelector", languageSelector.get());

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated, &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    QObject::connect(languageSelector.get(), &LanguageSelector::languageChanged,
                     &engine, &QQmlApplicationEngine::retranslate);
    engine.load(url);

    return app.exec();
}
