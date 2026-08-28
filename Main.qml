pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import xRumi.QWeather

Window {
    width: 430
    height: 750
    visible: true
    title: qsTr("Weather App")

    // qml element from c++ class
    WeatherData {
        id: weatherElement
        onWeatherLocationChanged: {
            weatherElement.updateWeatherData()
        }
        onWeatherDataChanged: {
            AppState.weatherData = weatherElement.weatherData
        }
    }

    // Background gradient
    // Changes gradient color according to weather code
    Rectangle {
        id: backgroundGradient
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: Qt.quit()
        gradient: Gradient {
            GradientStop { position: 0; color: AppState.color.gradientTop }
            GradientStop { position: 1; color: AppState.color.gradientBottom }
        }
    }

    // updates location header date every 1 sec
    // updates weather data every hour
    Timer {
        property int previousHour: 123 // anything above 23, forces weatherData.updateWeatherLocation() the first time

        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            let date = new Date()
            let hours = date.getHours()
            let pm = hours >= 12

            locationArea.date = `${days[date.getDay()]}, ${(hours % 12) || 12}:${date.getMinutes().toString().padStart(2, '0')} ${pm ? "PM" : "AM"}`

            if (previousHour != hours) {
                weatherElement.updateWeatherLocation()
                previousHour = hours
            }
        }
    }
    // updates weather data every 15 minutes
    Timer {
        interval: 15 * 60 * 1000
        repeat: true
        running: true
        onTriggered: weatherElement.updateWeatherLocation()
    }

    // bouncing dots for loading animation
    BouncingDots {
        anchors.fill: parent
        anchors.topMargin: 400
        visible: !weatherElement.isWeatherDataReady
    }

    // main body
    ColumnLayout {
        anchors.fill: parent

        // top bar
        Header {
            weatherLocation: weatherElement.weatherLocation

            id: locationArea
            Layout.topMargin: weatherElement.isWeatherDataReady ? 0 : (parent.height - height) / 2
            Behavior on Layout.topMargin {
                NumberAnimation {
                    duration: Qt.platform.os === "android" ? 50 : 500
                    easing.type: Easing.OutQuad
                }
            }
        }

        PageIndicator {
            id: pageIndicator
            count: swipeView.count
            currentIndex: swipeView.currentIndex
            Layout.topMargin: 5
            Layout.alignment: Qt.AlignHCenter
            visible: weatherElement.isWeatherDataReady
            delegate: Rectangle {
                required property int index

                width: pageIndicator.currentIndex === index ? 10 : 6
                height: width
                radius: width / 2
                color: AppState.color.text1
                Behavior on width {
                    NumberAnimation { duration: 100 }
                }
            }
        }

        SwipeView {
            id: swipeView
            currentIndex: 0
            interactive: weatherElement.isWeatherDataReady

            Layout.fillHeight: true
            Layout.fillWidth: true

            ColumnLayout {
                CurrentTemps {
                    weatherData: weatherElement.weatherData

                    id: dailyWeatherArea
                    opacity: weatherElement.isWeatherDataReady ? 1 : 0
                    Layout.topMargin: 80
                    Layout.rightMargin: 5
                    Layout.leftMargin: 5

                    Behavior on opacity {
                        OpacityAnimator { duration: 500 }
                    }
                }

                WeatherGraph {
                    // for weather graph showing temperatures
                    yS: weatherElement.weatherData["dailyForecastTemps"] || []
                    xS: weatherElement.weatherData["dailyForecastHours"] || []
                    ySuffix: "°"
                    weatherCodes: weatherElement.weatherData["dailyForecastWeatherCodes"] || []

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.topMargin: 50
                    Layout.maximumHeight: 300
                }
            }

            ColumnLayout {
                CurrentDetails {
                    backgroundItem: backgroundGradient

                    Layout.topMargin: 80
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
                WeatherGraph {
                    // for weather graph showing precipitation probabilities
                    yS: weatherElement.weatherData["dailyForecastPrecipitationProbability"] || []
                    xS: weatherElement.weatherData["dailyForecastHours"] || []
                    ySuffix: "%"
                    weatherCodes: weatherElement.weatherData["dailyForecastWeatherCodes"] || []

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.topMargin: 25
                    Layout.maximumHeight: 300
                }
            }

            // for live updates from temperature and humidity sensor
            Sensor {}
        }
    }
}
