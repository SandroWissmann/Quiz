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
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQuickWindow>

#include "include/databasemanager.h"
#include "include/languageselector.h"
#include "include/questionsproxymodel.h"
#include "include/randomquestionfiltermodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setOrganizationName("Sandro Wißmann");
    app.setOrganizationDomain("Sandro Wißmann Private");

    QScopedPointer<DatabaseManager> databaseManager{new DatabaseManager};

    QScopedPointer<LanguageSelector> languageSelector(new LanguageSelector);

    QQmlApplicationEngine engine;

    qmlRegisterSingletonInstance<DatabaseManager>(
        "DatabaseManagers", 1, 0, "DatabaseManager", databaseManager.get());

    qmlRegisterSingletonInstance<QuestionsProxyModel>(
        "QuestionsProxyModels", 1, 0, "QuestionsProxyModel",
        databaseManager->questionsProxyModel());

    qmlRegisterSingletonInstance<RandomQuestionFilterModel>(
        "RandomQuestionFilterModels", 1, 0, "RandomQuestionFilterModel",
        databaseManager->randomQuestionFilterModel());

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

    QObject *object = engine.rootObjects().first();

    QObject::connect(object, SIGNAL(rowMarkedForDeleteFromDatabase(int)),
                     databaseManager->questionsProxyModel(),
                     SLOT(removeEntry(int)));

    QObject::connect(
        object, SIGNAL(valueMarkedForUpdateInDatabase(int, QVariant, QString)),
        databaseManager->questionsProxyModel(),
        SLOT(changeValue(int, QVariant, QString)));

    return app.exec();
}
