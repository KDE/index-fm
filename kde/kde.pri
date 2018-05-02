QT += KService KNotifications KNotifications KI18n
QT += KIOCore KIOFileWidgets KIOWidgets KNTLM

desktop.files += $$PWD../org.kde.index.desktop
desktop.path += /usr/share/applications

INSTALLS += desktop

DISTFILES += \
    $$PWD/kde.pri

HEADERS += \
    $$PWD/kde.h \
    $$PWD/kdeconnect.h \
    $$PWD/notify.h

SOURCES += \
    $$PWD/kde.cpp \
    $$PWD/kdeconnect.cpp \
    $$PWD/notify.cpp
