QT += qml
QT += quick
QT += sql

CONFIG += c++11
TARGET = index
DESTDIR = $$OUT_PWD/../

linux:unix:!android {

    message(Building for Linux KDE)
    include($$PWD/../kde/kde.pri)

} else:android {

    message(Building helpers for Android)
    include($$PWD/../mauikit/mauikit.pri)
    include($$PWD/../3rdparty/kirigami/kirigami.pri)

    DEFINES += STATIC_KIRIGAMI

} else {
    message("Unknown configuration")
}

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += main.cpp \
    index.cpp

RESOURCES += qml.qrc \
    assets.qrc \

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    index.h \
    inx.h

include($$PWD/../install.pri)

DISTFILES += \
    ../org.kde.index.desktop
