/*
 *   Copyright 2016 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>

class Settings : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool isMobile READ isMobile NOTIFY isMobileChanged)
    Q_PROPERTY(QString style READ style CONSTANT)
    //TODO: make this adapt without file watchers?
    Q_PROPERTY(int mouseWheelScrollLines READ mouseWheelScrollLines CONSTANT)

public:
    Settings(QObject *parent=0);
    ~Settings();

    void setIsMobile(bool mobile);
    bool isMobile() const;

    QString style() const;
    void setStyle(const QString &style);

    int mouseWheelScrollLines() const;

Q_SIGNALS:
    void isMobileChanged();

private:
    QString m_style;
    int m_scrollLines = 0;
    bool m_mobile : 1;
};

#endif
