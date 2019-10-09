project(index)
cmake_minimum_required(VERSION 3.0)

find_package(ECM 1.7.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${ECM_MODULE_PATH})
option(IS_APPIMAGE_PACKAGE "If set to true then the icons and styled is packaged as well")

find_package(Qt5 REQUIRED NO_MODULE COMPONENTS Qml Quick Sql Svg QuickControls2 Widgets)
include(KDEInstallDirs)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDECMakeSettings)
include(ECMInstallIcons)
include(FeatureSummary)
include(ECMAddAppIcon)


set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(index
    src/index_assets.qrc
    src/main.cpp
    src/index.cpp
    src/qml.qrc
    )

if(IS_APPIMAGE_PACKAGE)
    target_compile_definitions(index PUBLIC APPIMAGE_PACKAGE)
endif()

if (ANDROID)
    find_package(Qt5 REQUIRED COMPONENTS AndroidExtras)

    target_link_libraries(index Qt5::AndroidExtras)
    kde_source_files_enable_exceptions(index src/index.cpp)
else()

    find_package(Qt5 REQUIRED COMPONENTS WebEngine)

    if(IS_APPIMAGE_PACKAGE)
        find_package(MauiKit REQUIRED)
        find_package(KF5 ${KF5_VERSION} REQUIRED COMPONENTS I18n Notifications Config KIO Service Attica)
        target_link_libraries(index KF5::KIOWidgets KF5::KIOFileWidgets KF5::ConfigCore KF5::Notifications KF5::KIOCore KF5::KIOWidgets KF5::I18n KF5::Service KF5::Attica)
    endif()

endif()

if (TARGET create-apk-index)
    set_target_properties(create-apk-index PROPERTIES ANDROID_APK_DIR "${MAUIKIT_ANDROID_DIR}")
endif()

if(IS_APPIMAGE_PACKAGE)
    target_link_libraries(index MauiKit Qt5::Sql Qt5::Quick Qt5::Qml Qt5::Widgets Qt5::Svg)
else()
    target_link_libraries(index Qt5::Sql Qt5::Quick Qt5::Qml Qt5::Widgets Qt5::Svg)
endif()

install(TARGETS index ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
install(FILES org.kde.index.desktop DESTINATION ${XDG_APPS_INSTALL_DIR})

#TODO: port to ecm_install_icons()
install(FILES src/assets/index.svg DESTINATION ${KDE_INSTALL_ICONDIR}/hicolor/scalable/apps)
# install(FILES org.kde.index.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})

feature_summary(WHAT ALL   FATAL_ON_MISSING_REQUIRED_PACKAGES)
