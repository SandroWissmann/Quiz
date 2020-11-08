#include "../include/languageselector.h"

#include <QDebug>
#include <QGuiApplication>
#include <QLocale>
#include <QMetaEnum>
#include <QTranslator>

LanguageSelector::LanguageSelector(QObject *parent)
    : QObject{parent}, mTranslator{new QTranslator{this}}
{
}

void LanguageSelector::changeLanguage(Language newLanguage)
{
    qApp->removeTranslator(mTranslator);
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
    qApp->installTranslator(mTranslator);
    mLanguage = newLanguage;
    emit languageChanged();
}

QTranslator *LanguageSelector::getTranslator() const
{
    return mTranslator;
}

void LanguageSelector::loadLanguage(const QLocale::Language &newLanguage)
{
    if (!mTranslator->load(QLocale(newLanguage), QLatin1String("quiz"),
                           QLatin1String("."),
                           QLatin1String(":/translations"))) {
        auto metaEnum = QMetaEnum::fromType<QLocale::Language>();
        qDebug() << tr("load language %1 failed")
                        .arg(metaEnum.valueToKey(newLanguage));
    }
}
