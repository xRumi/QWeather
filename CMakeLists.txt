cmake_minimum_required(VERSION 3.16)

project(QWeather VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(qWeather
    main.cpp
)

set(qml_singletons
    qml/AppTheme.qml
)
set_source_files_properties(${qml_singletons}
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(qWeather
    URI QWeather
    QML_FILES
        Main.qml
        SOURCES weatherdata.h weatherdata.cpp
        QML_FILES qml/AppTheme.qml
        QML_FILES qml/LocationHeader.qml
        QML_FILES qml/ForecastView.qml
        QML_FILES qml/WeatherGraph.qml
        RESOURCES assets/icons/cloud-lightning.svg assets/icons/moon.svg  assets/icons/sun.svg
        RESOURCES assets/icons/cloud-fog.svg assets/icons/cloud-lightning.svg assets/icons/cloud-moon.svg assets/icons/cloud-rain.svg assets/icons/cloud-sun.svg assets/icons/cloud.svg assets/icons/moon.svg assets/icons/sun-dim.svg assets/icons/sun.svg
        QML_FILES qml/BouncingDots.qml
)
# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(qWeather PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.qWeather
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(qWeather
    PRIVATE Qt6::Quick
)

install(TARGETS qWeather
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
