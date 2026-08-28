cmake_minimum_required(VERSION 3.16)

project(QWeather VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

if (NOT ANDROID)
    find_package(Qt6 REQUIRED COMPONENTS SerialPort)
endif()

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(QWeather
    main.cpp
)

set_target_properties(QWeather PROPERTIES
   QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")

set(qml_singletons
    qml/AppState.qml
)
set_source_files_properties(${qml_singletons}
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(QWeather
    URI xRumi.QWeather
    QML_FILES
        Main.qml
        SOURCES weatherdata.h weatherdata.cpp
        QML_FILES qml/AppState.qml
        QML_FILES qml/Header.qml
        QML_FILES qml/CurrentTemps.qml
        QML_FILES qml/WeatherGraph.qml
        QML_FILES qml/BouncingDots.qml
        RESOURCES assets/icons/drop-light.svg
        QML_FILES qml/CurrentDetails.qml
        RESOURCES assets/icons/cloud-fog.svg assets/icons/cloud-lightning.svg assets/icons/cloud-moon.svg assets/icons/cloud-rain.svg assets/icons/cloud-sun.svg assets/icons/cloud.svg assets/icons/drop-light.svg assets/icons/eye-light.svg assets/icons/moon.svg assets/icons/speedometer-light.svg assets/icons/sun-dim.svg assets/icons/sun.svg assets/icons/thermometer-cold-light.svg assets/icons/thermometer-hot-light.svg assets/icons/thermometer-light.svg assets/icons/thermometer-simple-light.svg assets/icons/wind-light.svg
        QML_FILES qml/Sensor.qml
        SOURCES SensorManager.h
        SOURCES SensorManager.cpp
        SOURCES receiverthread.h receiverthread.cpp
)
# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(QWeather PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.qWeather
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(QWeather
    PRIVATE Qt6::Quick
)

if (NOT ANDROID)
    target_link_libraries(QWeather PRIVATE Qt6::SerialPort)
endif()

if (ANDROID)
    include(${ANDROID_SDK_ROOT}/android_openssl/android_openssl.cmake)
    add_android_openssl_libraries(QWeather)
endif()

install(TARGETS QWeather
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

file(GLOB_RECURSE InstallerFiles "installer/*")
add_custom_target(CreateInstaller
    COMMAND ls
    SOURCES ${InstallerFiles}
    COMMENT "Doing something custom"
    DEPENDS qWeather
)