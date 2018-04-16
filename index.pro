TEMPLATE = subdirs

CONFIG += ordered

SUBDIRS += qmltermwidget
SUBDIRS += app

desktop.files += org.kde.index.desktop
desktop.path += /usr/share/applications

INSTALLS += desktop
