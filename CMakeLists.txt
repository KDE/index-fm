project(index)
cmake_minimum_required(VERSION 3.0)

set(REQUIRED_QT_VERSION 5.10.0)
set(REQUIRED_KF5_VERSION 5.60)

find_package(ECM ${REQUIRED_KF5_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${ECM_MODULE_PATH})
option(IS_APPIMAGE_PACKAGE "If set to true then the icons and styled is packaged as well")

find_package(Qt5 ${REQUIRED_QT_VERSION} REQUIRED NO_MODULE COMPONENTS Qml Quick Sql Svg QuickControls2 Widgets)
find_package(KF5 ${REQUIRED_KF5_VERSION} REQUIRED COMPONENTS I18n Notifications KIO Attica)

if(ANDROID)
    find_package(Qt5 ${REQUIRED_QT_VERSION} REQUIRED NO_MODULE COMPONENTS AndroidExtras)
endif()

find_package(MauiKit REQUIRED)

include(KDEInstallDirs)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDECMakeSettings)
include(ECMInstallIcons)
include(FeatureSummary)
include(ECMAddAppIcon)

add_subdirectory(src)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
