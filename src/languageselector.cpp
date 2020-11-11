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
