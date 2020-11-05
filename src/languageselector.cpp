#include "../include/languageselector.h"

#include <QDebug>
#include <QGuiApplication>
#include <QLocale>
#include <QMetaEnum>
#include <QTranslator>

LanguageSelector::LanguageSelector(QObject *parent)
    : QObject{parent}, mTranslator{new QTranslator{this}}
{
    loadLanguage(QLocale::English);
}

void LanguageSelector::changeLanguage(Language newLanguage)
{
    qApp->removeTranslator(mTranslator);
    switch (newLanguage) {
    case Language::german:
        loadLanguage(QLocale::German);
        break;
    case Language::english:
        loadLanguage(QLocale::English);
        break;
    case Language::spanish:
        loadLanguage(QLocale::Spanish);
        break;
    }
    qApp->installTranslator(mTranslator);
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
