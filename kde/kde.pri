QT += KService KNotifications KNotifications KI18n
QT += KIOCore KIOFileWidgets KIOWidgets KNTLM

desktop.files += $$PWD../org.kde.index.desktop
desktop.path += /usr/share/applications

INSTALLS += desktop
