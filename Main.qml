import QtQuick
import QtQuick.Layouts
import QWeather

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
        LocationHeader {
            weatherLocation: weatherElement.weatherLocation

            id: locationArea
            Layout.topMargin: weatherElement.isWeatherDataReady ? 0 : (parent.height - height) / 2
            Behavior on Layout.topMargin {
                NumberAnimation { duration: 500 }
            }
        }

        ForecastView {
            weatherData: weatherElement.weatherData

            id: dailyWeatherArea
            opacity: weatherElement.isWeatherDataReady ? 1 : 0
            Layout.leftMargin: 25
            Layout.topMargin: 100
            Layout.alignment: Qt.AlignCenter
            Layout.fillHeight: true
            Layout.fillWidth: true

            Behavior on opacity {
                OpacityAnimator { duration: 1000 }
            }
        }
    }
}
