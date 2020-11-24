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
#include "../include/languageselector.h"

#include <QDebug>
#include <QGuiApplication>
#include <QLocale>
#include <QMetaEnum>
#include <QTranslator>

LanguageSelector::LanguageSelector(QObject *parent)
    : QObject{parent}, mAppTranslator{new QTranslator{this}},
      mQtBaseTranslator{new QTranslator{this}}, mQtQuickControlsTranslator{
                                                    new QTranslator{this}}
{
}

LanguageSelector::Language LanguageSelector::language() const
{
    return mLanguage;
}

void LanguageSelector::setLanguage(Language newLanguage)
{
    switch (newLanguage) {
    case Language::German:
        loadLanguage(QLocale::German);
        break;
    case Language::English:
        qApp->removeTranslator(mAppTranslator);
        qApp->removeTranslator(mQtBaseTranslator);
        qApp->removeTranslator(mQtQuickControlsTranslator);
        break;
    case Language::Spanish:
        loadLanguage(QLocale::Spanish);
        break;
    }
    mLanguage = newLanguage;
    emit languageChanged();
}

QTranslator *LanguageSelector::getTranslator() const
{
    return mAppTranslator;
}

void LanguageSelector::loadLanguage(const QLocale::Language &newLanguage)
{
    qApp->removeTranslator(mAppTranslator);
    if (!mAppTranslator->load(QLocale(newLanguage), QStringLiteral("quiz"),
                              QStringLiteral("."),
                              QStringLiteral(":/translations"))) {
        auto metaEnum = QMetaEnum::fromType<QLocale::Language>();
        qDebug() << tr("load app translator language %1 failed")
                        .arg(metaEnum.valueToKey(newLanguage));
    }
    qApp->installTranslator(mAppTranslator);

    qApp->removeTranslator(mQtBaseTranslator);
    if (!mQtBaseTranslator->load(QLocale(newLanguage), QStringLiteral("qtbase"),
                                 QStringLiteral("."),
                                 QStringLiteral(":/translations"))) {
        auto metaEnum = QMetaEnum::fromType<QLocale::Language>();
        qDebug() << tr("load qt base translator language %1 failed")
                        .arg(metaEnum.valueToKey(newLanguage));
    }
    qApp->installTranslator(mQtBaseTranslator);

    qApp->removeTranslator(mQtQuickControlsTranslator);
    if (!mQtQuickControlsTranslator->load(
            QLocale(newLanguage), QStringLiteral("qtquickcontrols"),
            QStringLiteral("."), QStringLiteral(":/translations"))) {
        auto metaEnum = QMetaEnum::fromType<QLocale::Language>();
        qDebug() << tr("load qt quick controls translator language %1 failed")
                        .arg(metaEnum.valueToKey(newLanguage));
    }
    qApp->installTranslator(mQtQuickControlsTranslator);
}
