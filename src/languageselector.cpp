#include "../include/languageselector.h"

#include <QDebug>
#include <QGuiApplication>
#include <QLocale>
#include <QMetaEnum>
#include <QTranslator>

LanguageSelector::LanguageSelector(QObject *parent)
    : QObject{parent}, mAppTranslator{new QTranslator{this}},
      mQtTranslator{new QTranslator{this}}
{
}

LanguageSelector::Language LanguageSelector::language() const
{
    return mLanguage;
}

void LanguageSelector::setLanguage(Language newLanguage)
{
    qApp->removeTranslator(mAppTranslator);
    qApp->removeTranslator(mQtTranslator);
    switch (newLanguage) {
    case Language::German:
        loadLanguage(QLocale::German);
        break;
    case Language::English:
        loadLanguage(QLocale::English);
        break;
    case Language::Spanish:
        loadLanguage(QLocale::Spanish);
        break;
    }
    qApp->installTranslator(mAppTranslator);
    qApp->installTranslator(mQtTranslator);
    mLanguage = newLanguage;
    emit languageChanged();
}

QTranslator *LanguageSelector::getTranslator() const
{
    return mAppTranslator;
}

void LanguageSelector::loadLanguage(const QLocale::Language &newLanguage)
{
    if (!mAppTranslator->load(QLocale(newLanguage), QStringLiteral("quiz"),
                              QStringLiteral("."),
                              QStringLiteral(":/translations"))) {
        auto metaEnum = QMetaEnum::fromType<QLocale::Language>();
        qDebug() << tr("load app translator language %1 failed")
                        .arg(metaEnum.valueToKey(newLanguage));
    }

    if (!mQtTranslator->load(
            QLocale(newLanguage), QStringLiteral("qtquickcontrols"),
            QStringLiteral("."), QStringLiteral(":/translations"))) {
        auto metaEnum = QMetaEnum::fromType<QLocale::Language>();
        qDebug() << tr("load qt translator language %1 failed")
                        .arg(metaEnum.valueToKey(newLanguage));
    }
}
