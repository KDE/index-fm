# Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2020 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later

cmake_minimum_required(VERSION 3.14)

set(INDEX_VERSION 2.0.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

project(index VERSION ${INDEX_VERSION})

set(REQUIRED_QT_VERSION 5.14.0)
set(REQUIRED_KF5_VERSION 5.40.0)

find_package(ECM ${REQUIRED_KF5_VERSION} NO_MODULE)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${ECM_MODULE_PATH})

if(UNIX AND NOT APPLE AND NOT ANDROID)
    include(KDEInstallDirs)
    include(KDECMakeSettings)
    include(ECMInstallIcons)
    include(ECMAddAppIcon)
endif()

include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDEClangFormat)
include(ECMSetupVersion)
include(ECMSourceVersionControl)
include(FeatureSummary)
include(ECMQMLModules)

find_package(Qt5 ${REQUIRED_QT_VERSION} REQUIRED NO_MODULE COMPONENTS Qml Quick Sql Svg QuickControls2 Concurrent)
find_package(KF5 ${REQUIRED_KF5_VERSION} REQUIRED COMPONENTS I18n CoreAddons Archive)

if(ANDROID)
    find_package(Qt5 ${REQUIRED_QT_VERSION} REQUIRED NO_MODULE COMPONENTS AndroidExtras QuickControls2)
    message("CURRENT DIR" ${CMAKE_CURRENT_SOURCE_DIR})
    set(ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android_files)
    set(ANDROID_ABIS "armeabi-v7a")
elseif(UNIX)
    find_package(KF5 ${REQUIRED_KF5_VERSION} REQUIRED COMPONENTS Config KIO)
endif()

find_package(MauiKit REQUIRED)
find_package(MauiKit REQUIRED COMPONENTS FileBrowsing)

#ecm_find_qmlmodule(org.mauikit.filebrowsing)
#ecm_find_qmlmodule(org.mauikit.controls)
#ecm_find_qmlmodule(org.mauikit.texteditor 1.0)
#ecm_find_qmlmodule(QMLTermWidget 1.0)
#ecm_find_qmlmodule(QtQuick.Shapes 1.0)
#ecm_find_qmlmodule(org.kde.kirigami 2.10)


if(${ECM_SOURCE_UNDER_VERSION_CONTROL})
execute_process(
  COMMAND git rev-parse --abbrev-ref HEAD
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  OUTPUT_VARIABLE GIT_BRANCH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

# Get the latest abbreviated commit hash of the working branch
execute_process(
  COMMAND git log -1 --format=%h
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  OUTPUT_VARIABLE GIT_COMMIT_HASH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

add_definitions(-DGIT_COMMIT_HASH="${GIT_COMMIT_HASH}")
add_definitions(-DGIT_BRANCH="${GIT_BRANCH}")

else()
    add_definitions(-DGIT_COMMIT_HASH="${INDEX_VERSION}")
    add_definitions(-DGIT_BRANCH="Stable")
endif()

ecm_setup_version(${INDEX_VERSION}
    VARIABLE_PREFIX INDEX
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/index_version.h"
    )

add_subdirectory(src)

if(UNIX AND NOT APPLE AND NOT ANDROID)
    install(FILES org.kde.index.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})
endif()

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)

file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})
