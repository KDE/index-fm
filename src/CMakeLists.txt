# Copyright 2018-2021 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2021 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later

set(index_SRCS
    main.cpp
    index.cpp
    controllers/filepreviewer.cpp
    controllers/compressedfile.cpp
    controllers/dirinfo.cpp
    controllers/folderconfig.cpp
    controllers/sessionmanager.cpp
    controllers/fileproperties.cpp
    models/recentfilesmodel.cpp
    models/pathlist.cpp
    index_assets.qrc
    data/data.qrc
    )

if(QUICK_COMPILER)
    qtquick_compiler_add_resources(index_QML_QRC qml.qrc)
else()
    qt5_add_resources(index_QML_QRC qml.qrc)
endif()

if(ANDROID)
    add_library(${PROJECT_NAME} SHARED ${index_SRCS} ${index_QML_QRC})
else()
    add_executable(${PROJECT_NAME} ${index_SRCS} ${index_QML_QRC})
endif()

if (ANDROID)
    target_link_libraries(${PROJECT_NAME}
        Qt5::AndroidExtras
        Qt5::QuickControls2)
    kde_source_files_enable_exceptions(${PROJECT_NAME} index.cpp)

    #    set_target_properties(create-apk-${PROJECT_NAME} PROPERTIES ANDROID_APK_DIR "${APK_DIR}")

elseif(UNIX)
    target_link_libraries(${PROJECT_NAME} KF5::KIOCore)
endif()

if(UNIX OR WIN32 OR APPLE AND NOT ANDROID)
    target_link_libraries(${PROJECT_NAME} Qt5::Widgets)
endif()

target_compile_definitions(${PROJECT_NAME}
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(${PROJECT_NAME}
    MauiKit
    MauiKit::FileBrowsing
    Qt5::Quick
    Qt5::Qml
    Qt5::PrintSupport
    KF5::Archive
    KF5::CoreAddons
    KF5::I18n)

#TODO: port to ecm_install_icons()
if(UNIX AND NOT APPLE AND NOT ANDROID)
    install(TARGETS ${PROJECT_NAME} ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
    install(FILES org.kde.index.desktop DESTINATION ${XDG_APPS_INSTALL_DIR})

    install(FILES assets/index.svg DESTINATION ${KDE_INSTALL_ICONDIR}/hicolor/scalable/apps)
endif()

