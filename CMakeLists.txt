# Copyright 2018-2021 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2021 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later

cmake_minimum_required(VERSION 3.16)

set(INDEX_VERSION 4.0.1)
add_compile_definitions(INDEX_COPYRIGHT_NOTICE="© 2019-2024 Maui Development Team")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

project(index VERSION ${INDEX_VERSION})

set(QT_MAJOR_VERSION 6)

set(REQUIRED_QT_VERSION 6.5.2)
set(REQUIRED_KF_VERSION 5.240.0)
set(REQUIRED_MAUI_VERSION 3.0.0)

if(ANDROID)
    set(ANDROID_ABIS "armeabi-v7a")
endif()

find_package(ECM ${REQUIRED_KF_VERSION} NO_MODULE)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${ECM_MODULE_PATH})

if(UNIX AND NOT APPLE AND NOT ANDROID)
    include(KDEInstallDirs)
    include(KDECMakeSettings)
endif()

include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDEClangFormat)

include(ECMSetupVersion)
include(ECMSourceVersionControl)
include(ECMFindQmlModule)
include(FeatureSummary)

find_package(Qt6 ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS Core Multimedia Sql Qml Quick QuickControls2)
find_package(KF6 ${REQUIRED_KF_VERSION} REQUIRED COMPONENTS I18n CoreAddons Archive)

if(ANDROID)
    find_package(Qt6 ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS QuickControls2)
elseif(UNIX)
    find_package(Qt6 ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS DBus)
    find_package(KF6 ${REQUIRED_KF_VERSION} REQUIRED COMPONENTS KIO)

    ecm_find_qmlmodule(org.mauikit.terminal)
endif()

if(UNIX OR WIN32 OR APPLE AND NOT ANDROID)
    find_package(Qt6 ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS Widgets)
endif()

find_package(MauiKit4 ${REQUIRED_MAUI_VERSION} REQUIRED COMPONENTS FileBrowsing)

ecm_find_qmlmodule(org.mauikit.controls)
ecm_find_qmlmodule(org.mauikit.filebrowsing)
ecm_find_qmlmodule(org.mauikit.documents)
ecm_find_qmlmodule(org.mauikit.archiver)

ecm_find_qmlmodule(org.kde.purpose)

if(ECM_SOURCE_UNDER_VERSION_CONTROL)
    execute_process(
        COMMAND git rev-parse --abbrev-ref HEAD
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_BRANCH
        OUTPUT_STRIP_TRAILING_WHITESPACE)

    # Get the latest abbreviated commit hash of the working branch
    execute_process(
        COMMAND git log -1 --format=%h
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_COMMIT_HASH
        OUTPUT_STRIP_TRAILING_WHITESPACE)

    add_definitions(-DGIT_COMMIT_HASH="${GIT_COMMIT_HASH}")
    add_definitions(-DGIT_BRANCH="${GIT_BRANCH}")

else()
    add_definitions(-DGIT_COMMIT_HASH="${INDEX_VERSION}")
    add_definitions(-DGIT_BRANCH="${CMAKE_BUILD_TYPE}")
endif()

ecm_setup_version(${INDEX_VERSION}
    VARIABLE_PREFIX INDEX
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/index_version.h")

add_subdirectory(src)

if(UNIX AND NOT APPLE AND NOT ANDROID)
    install(FILES org.kde.index.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})
    install(FILES src/data/org.kde.index.notifyrc DESTINATION ${KDE_INSTALL_KNOTIFYRCDIR})
endif()

ki18n_install(po)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)

file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})

qt_finalize_project()
