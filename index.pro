# Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2020 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later

QT *= core \
    quick \
    multimedia \
    sql \
    qml \
    widgets \
    quickcontrols2

CONFIG += ordered
CONFIG += c++17

TARGET = index
TEMPLATE = app

VERSION_MAJOR = 1
VERSION_MINOR = 2
VERSION_BUILD = 1

VERSION = $${VERSION_MAJOR}.$${VERSION_MINOR}.$${VERSION_BUILD}

DEFINES += INDEX_VERSION_STRING=\\\"$$VERSION\\\"

linux:unix:!android {
} else {
    message(Building helpers for Android Windows or Mac)
    DEFINES += STATIC_KIRIGAMI

#DEFAULT COMPONENTS DEFINITIONS
    DEFINES *= \
        COMPONENT_FM \
        COMPONENT_EDITOR \
        COMPONENT_TAGGING \
        MAUIKIT_STYLE

    DEFINES -= COMPONENT_STORE

    include($$PWD/3rdparty/kirigami/kirigami.pri)
    include($$PWD/3rdparty/mauikit/mauikit.pri)
}

ios {
    QMAKE_INFO_PLIST = $$PWD/ios_files/Info.plist
}

macos {
    DEFINES += EMBEDDED_TERMINAL
    ICON = $$PWD/macos_files/index.icns

    LIBS += -L$$PWD/../../../usr/local/Cellar/kde-karchive/5.74.0/lib/ -lKF5Archive.5.74.0

    INCLUDEPATH += $$PWD/../../../usr/local/Cellar/kde-karchive/5.74.0/include/KF5
    DEPENDPATH += $$PWD/../../../usr/local/Cellar/kde-karchive/5.74.0/include/KF5
}

win32 {
    RC_ICONS = $$PWD/windows_files/index.ico
    LIBS += -LC:/CraftRoot/lib/ -lKF5Archive

    INCLUDEPATH += C:/CraftRoot/include/KF5
    DEPENDPATH += C:/CraftRoot/include/KF5
}

android {
    message(Building helpers for Android)
    KARCHIVE_ANDROID_REPO = https://github.com/mauikit/KArchive-android

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android_files
    DISTFILES += $$PWD/android_files/AndroidManifest.xml
    exists($$PWD/3rdparty/KArchive) {
        message("Using KArchive for Android")

    }else {
        warning("Getting KArchive for Android")
        system(git clone $$KARCHIVE_ANDROID_REPO $$PWD/3rdparty/KArchive)
    }

    ANDROID_EXTRA_LIBS += $$PWD/3rdparty/KArchive/libKF5Archive_armeabi-v7a.so \

    LIBS += -L$$PWD/3rdparty/KArchive/ -lKF5Archive_armeabi-v7a

    INCLUDEPATH += $$PWD/3rdparty/KArchive
    DEPENDPATH += $$PWD/3rdparty/KArchive

    ANDROID_ABIS = armeabi-v7a
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

SOURCES += \
    $$PWD/src/main.cpp \
    $$PWD/src/index.cpp \
    $$PWD/src/controllers/compressedfile.cpp \
    $$PWD/src/controllers/filepreviewer.cpp

HEADERS += \
    $$PWD/src/index.h \
    $$PWD/src/controllers/compressedfile.h \
    $$PWD/src/controllers/filepreviewer.h

RESOURCES += \
    $$PWD/src/qml.qrc \
    $$PWD/src/index_assets.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =
# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

include($$PWD/install.pri)

ANDROID_ABIS = armeabi-v7a

