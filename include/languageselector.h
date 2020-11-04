#ifndef LANGUAGESELECTOR_H
#define LANGUAGESELECTOR_H

#include <QLocale>
#include <QObject>

class QTranslator;

class LanguageSelector : public QObject {
    Q_OBJECT
public:
    enum class Language { german, english, spanish };
    Q_ENUM(Language)

    explicit LanguageSelector(QObject *parent = nullptr);

    Q_INVOKABLE void changeLanguage(Language newLanguage);

    QTranslator *getTranslator() const;

private:
    QTranslator *mTranslator;

    void loadGerman();
    void loadEnglish();
    void loadSpanish();

    void loadLanguage(const QLocale::Language &newLanguage);

signals:
    void languageChanged();
};

Q_DECLARE_METATYPE(LanguageSelector::Language);

#endif // LANGUAGESELECTOR_H
