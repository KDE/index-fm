TEMPLATE = subdirs

CONFIG += ordered

SUBDIRS += app

linux:unix:!android {
    message(Building Terminal for Linux KDE)
    SUBDIRS += kde/qmltermwidget
}
