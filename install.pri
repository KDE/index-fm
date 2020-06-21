# Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2020 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later


isEmpty(PREFIX){
    PREFIX = /usr
}

target.path = $${PREFIX}/bin/

desktop_files.path = $${PREFIX}/share/applications/
desktop_files.files = $$PWD/*.desktop

#services.path = $${PREFIX}/share/dbus-1/services
#services.files = $$PWD/data/*.service

#dman.path = $${PREFIX}/share/dman/
#dman.files = $$PWD/dman/*

#translations.path = $${PREFIX}/share/$${TARGET}/translations
#translations.files = $$PWD/translations/*.qm

hicolor.path =  $${PREFIX}/share/icons/hicolor/scalable/apps
hicolor.files = $$PWD/assets/index.svg

INSTALLS += target desktop_files hicolor

#GitVersion = $$system(git rev-parse HEAD)
#DEFINES += GIT_VERSION=\\\"$$GitVersion\\\"

