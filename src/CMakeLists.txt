# Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2020 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later

set(index_SRCS
    main.cpp
    index.cpp
    controllers/filepreviewer.cpp
    controllers/compressedfile.cpp
    controllers/dirinfo.cpp
    controllers/folderconfig.cpp
    models/recentfilesmodel.cpp
    models/pathlist.cpp
    index_assets.qrc
    qml.qrc
    )

if(UNIX AND NOT APPLE AND NOT ANDROID)
    if (EXISTS /usr/lib/qt/qml/QMLTermWidget OR EXISTS /lib/qt/qml/QMLTermWidget)
        message("QMLTermWidget found")
        set(QMLTermWidget_FOUND true)
    else()
        message("QMLTermWidget NOT found")
        set(QMLTermWidget_FOUND false)
    endif()

    if(QMLTermWidget_FOUND)
        add_definitions(-DEMBEDDED_TERMINAL)
    endif()
endif()

if(ANDROID)
    add_library(${PROJECT_NAME} SHARED ${index_SRCS})
else()
    add_executable(${PROJECT_NAME} ${index_SRCS})
endif()

if (ANDROID)
    target_link_libraries(${PROJECT_NAME} Qt5::AndroidExtras Qt5::QuickControls2)
    kde_source_files_enable_exceptions(${PROJECT_NAME} index.cpp)

#    set_target_properties(create-apk-${PROJECT_NAME} PROPERTIES ANDROID_APK_DIR "${APK_DIR}")

elseif(UNIX)
    target_link_libraries(${PROJECT_NAME} KF5::ConfigCore KF5::KIOCore KF5::KIOFileWidgets KF5::KIONTLM KF5::KIOWidgets)
endif()

target_compile_definitions(${PROJECT_NAME}
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(${PROJECT_NAME} MauiKit MauiKit::FileBrowsing Qt5::Sql Qt5::Quick Qt5::Qml Qt5::Svg KF5::Archive KF5::CoreAddons KF5::I18n)

#TODO: port to ecm_install_icons()
if(UNIX AND NOT APPLE AND NOT ANDROID)
    install(TARGETS ${PROJECT_NAME} ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
    install(FILES org.kde.index.desktop DESTINATION ${XDG_APPS_INSTALL_DIR})

    install(FILES assets/index.svg DESTINATION ${KDE_INSTALL_ICONDIR}/hicolor/scalable/apps)
endif()

