# Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2020 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later


cmake_minimum_required(VERSION 3.0)

set(INDEX_VERSION 1.2.1)
set(CMAKE_CXX_STANDARD 17)

project(index VERSION ${INDEX_VERSION})

set(REQUIRED_QT_VERSION 5.10.0)
set(REQUIRED_KF5_VERSION 5.60)

find_package(ECM ${REQUIRED_KF5_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${ECM_MODULE_PATH})
option(EMBEDDED_TERMINAL "If set to true then tries to load the QmlTermWidget. v 0.1 is needed later version might not work" OFF)

find_package(Qt5 ${REQUIRED_QT_VERSION} REQUIRED NO_MODULE COMPONENTS Qml Quick Sql Svg QuickControls2)
find_package(KF5 ${REQUIRED_KF5_VERSION} REQUIRED COMPONENTS I18n Notifications KIO Attica Archive)

if(ANDROID)
    find_package(Qt5 ${REQUIRED_QT_VERSION} REQUIRED NO_MODULE COMPONENTS AndroidExtras)
endif()

find_package(MauiKit REQUIRED)

include(KDEInstallDirs)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDECMakeSettings)
include(ECMInstallIcons)
include(ECMSetupVersion)
include(ECMAddAppIcon)
include(FeatureSummary)

ecm_setup_version(${INDEX_VERSION}
    VARIABLE_PREFIX INDEX
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/index_version.h"
    )

add_subdirectory(src)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
