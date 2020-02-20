add_executable(index
    index_assets.qrc
    main.cpp
    index.cpp
    qml.qrc
)

if(EMBEDDED_TERMINAL)
    target_compile_definitions(index PUBLIC EMBEDDED_TERMINAL)
endif()

if(IS_APPIMAGE_PACKAGE)
    target_compile_definitions(index PUBLIC APPIMAGE_PACKAGE)
endif()

if(MAUIKIT_STYLE)
    target_compile_definitions(index PUBLIC MAUIKIT_STYLE)
endif()

if (ANDROID)
    target_link_libraries(index Qt5::AndroidExtras)
    kde_source_files_enable_exceptions(index index.cpp)
endif()

target_link_libraries(index MauiKit Qt5::Sql Qt5::Quick Qt5::Qml Qt5::Widgets Qt5::Svg)

install(TARGETS index ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
install(FILES org.kde.index.desktop DESTINATION ${XDG_APPS_INSTALL_DIR})

#TODO: port to ecm_install_icons()
install(FILES assets/index.svg DESTINATION ${KDE_INSTALL_ICONDIR}/hicolor/scalable/apps)
# install(FILES org.kde.index.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})

