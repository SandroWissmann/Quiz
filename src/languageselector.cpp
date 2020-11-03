#include "../include/languageselector.h"

#include <QDebug>
#include <QFile>
#include <QGuiApplication>
#include <QLocale>
#include <QTranslator>

LanguageSelector::LanguageSelector(QObject *parent)
    : QObject{parent}, mTranslator{new QTranslator{this}}
{
    loadEnglish();
}

void LanguageSelector::selectLanguage(Language &language)
{
    switch (language) {
    case Language::german:
        qApp->removeTranslator(mTranslator);
        loadGerman();
        qApp->installTranslator(mTranslator);
        break;
    case Language::english:
        qApp->removeTranslator(mTranslator);
        loadEnglish();
        qApp->installTranslator(mTranslator);
        break;
    case Language::spanish:
        qApp->removeTranslator(mTranslator);
        loadSpanish();
        qApp->installTranslator(mTranslator);
        break;
    }
}

QTranslator *LanguageSelector::getTranslator() const
{
    return mTranslator;
}

void LanguageSelector::loadGerman()
{
    if (!mTranslator->load(QLocale(QLocale::German), QLatin1String("quiz.de"),
                           QLatin1String(":/translations"))) {
        qDebug() << "load german failed";
    }
}

void LanguageSelector::loadEnglish()
{
    QFile file(":/translations/quiz.en.qm");
    if (!file.open(stdout, QIODevice::ReadOnly)) {
        qDebug() << "Can't find it!";
    }

    if (!mTranslator->load(QLocale(QLocale::English), QLatin1String("quiz.en"),
                           QLatin1String(":/translations"))) {
        qDebug() << "load english failed";
    }
}

void LanguageSelector::loadSpanish()
{
    if (!mTranslator->load(QLocale(QLocale::Spanish), QLatin1String("quiz.es"),
                           QLatin1String(":/translations"))) {
        qDebug() << "load spanish failed";
    }
}
