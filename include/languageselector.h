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
#ifndef LANGUAGESELECTOR_H
#define LANGUAGESELECTOR_H

#include <QLocale>
#include <QObject>

class QTranslator;

/*
This class is designed to change the current application language at runtime
from QML
*/

class LanguageSelector : public QObject {
    Q_OBJECT
    Q_PROPERTY(Language language READ language WRITE setLanguage NOTIFY
                   languageChanged)
public:
    enum Language { German, English, Spanish };
    Q_ENUM(Language)

    explicit LanguageSelector(QObject *parent = nullptr);

    Language language() const;
    void setLanguage(Language newLanguage);

    QTranslator *getTranslator() const;

private:
    QTranslator *mAppTranslator;
    QTranslator *mQtBaseTranslator;
    QTranslator *mQtQuickControlsTranslator;
    Language mLanguage;

    void loadGerman();
    void loadEnglish();
    void loadSpanish();

    void loadLanguage(const QLocale::Language &newLanguage);

signals:
    void languageChanged();
};

Q_DECLARE_METATYPE(LanguageSelector::Language);

#endif // LANGUAGESELECTOR_H
