# Copyright 2018-2021 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2021 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later

remove_definitions(-DQT_NO_CAST_FROM_ASCII -DQT_STRICT_ITERATORS -DQT_NO_CAST_FROM_BYTEARRAY -DQT_NO_URL_CAST_FROM_STRING)

set(index_SRCS
    main.cpp
    index.cpp
    controllers/filepreviewer.cpp
    controllers/compressedfile.cpp
    controllers/dirinfo.cpp
    controllers/folderconfig.cpp
    controllers/sessionmanager.cpp
    controllers/fileproperties.cpp
    controllers/patharrowbackground.cpp
    models/recentfilesmodel.cpp
    models/pathlist.cpp
    data/data.qrc)

if(UNIX AND NOT ANDROID)
    qt_generate_dbus_interface(${CMAKE_CURRENT_SOURCE_DIR}/index.h org.kde.Index.xml)
    qt_add_dbus_adaptor(index_dbus_SRCS ${CMAKE_CURRENT_BINARY_DIR}/org.kde.Index.xml index.h Index)
    qt_add_dbus_interface(index_dbus_SRCS ${CMAKE_CURRENT_BINARY_DIR}/org.kde.Index.xml indexinterface)
endif()

qt_add_resources(index_RSCRS index_assets.qrc)

if(ANDROID)
    qt_add_executable(${PROJECT_NAME}
        MANUAL_FINALIZATION
        ${index_SRCS}
        ${index_RSCRS})
else()
    qt_add_executable(${PROJECT_NAME}
        ${index_SRCS}
        ${index_dbus_SRCS}
        ${index_RSCRS})
endif()

qt_add_qml_module(${PROJECT_NAME} URI app.maui.index
    NO_PLUGIN
    QML_FILES
    main.qml
    widgets/views/Browser.qml
    widgets/views/Terminal.qml
    widgets/views/TerminalColorSchemes.qml
    widgets/views/PlacesSideBar.qml
    widgets/views/BrowserLayout.qml
    widgets/views/SettingsDialog.qml
    widgets/previewer/DefaultPreview.qml
    widgets/previewer/DocumentPreview.qml
    widgets/previewer/FilePreviewer.qml
    widgets/previewer/PreviewerDialog.qml
    widgets/previewer/PreviewerWindow.qml
    widgets/previewer/ImagePreview.qml
    widgets/previewer/TextPreview.qml
    widgets/previewer/VideoPreview.qml
    widgets/previewer/AudioPreview.qml
    widgets/previewer/CompressedPreview.qml
    widgets/previewer/FontPreviewer.qml
    widgets/ColorsBar.qml
    widgets/views/FileMenu.qml
    widgets/views/PathBarDelegate.qml
    widgets/views/PathBar.qml
    widgets/views/ShortcutsDialog.qml
    widgets/views/BrowserView.qml
    widgets/views/TagsSection.qml
    widgets/views/RecentSection.qml
    widgets/views/HomeView.qml
    widgets/views/FavoritesSection.qml
    widgets/views/DisksSection.qml
    widgets/views/PlacesSection.qml
    widgets/views/home/Card.qml
    widgets/views/home/ImageCard.qml
    widgets/views/home/AudioCard.qml
    widgets/previewer/FileProperties.qml
    widgets/views/home/SectionGroup.qml)

if (ANDROID)
    target_link_libraries(${PROJECT_NAME}
        PRIVATE
        Qt6::QuickControls2)

    kde_source_files_enable_exceptions(${PROJECT_NAME} index.cpp)

    #    set_target_properties(create-apk-${PROJECT_NAME} PROPERTIES ANDROID_APK_DIR "${APK_DIR}")
elseif(UNIX)
    target_link_libraries(${PROJECT_NAME}
        PRIVATE
        KF6::KIOCore
        KF6::KIOFileWidgets
        Qt6::DBus)
endif()

if(UNIX OR WIN32 OR APPLE AND NOT ANDROID)
    target_link_libraries(${PROJECT_NAME} PRIVATE Qt6::Widgets)
endif()

target_compile_definitions(${PROJECT_NAME}
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
    MauiKit4
    MauiKit4::FileBrowsing
    Qt6::Core
    Qt6::Multimedia
    Qt6::Quick
    Qt6::Qml
    Qt6::Sql
    KF6::Archive
    KF6::CoreAddons
    KF6::I18n)

#TODO: port to ecm_install_icons()
if(UNIX AND NOT APPLE AND NOT ANDROID)
    install(TARGETS ${PROJECT_NAME} ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
    install(FILES org.kde.index.desktop DESTINATION ${KDE_INSTALL_APPDIR})

    install(FILES assets/index.svg DESTINATION ${KDE_INSTALL_ICONDIR}/hicolor/scalable/apps)
endif()

qt_finalize_target(${PROJECT_NAME})

