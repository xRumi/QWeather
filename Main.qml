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
        id: weatherData
        onWeatherLocationChanged: {
            weatherData.updateWeatherData()
        }
        onWeatherDataChanged: {
            AppTheme.weatherCode = weatherData.weatherData["weatherCode"]
            AppTheme.isNight = weatherData.weatherData["isNight"]
        }
    }

    // Background gradient
    // Changes gradient color according to weather code
    Rectangle {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: Qt.quit()
        gradient: Gradient {
            GradientStop { position: 0; color: AppTheme.color.gradientTop }
            GradientStop { position: 1; color: AppTheme.color.gradientBottom }
        }
    }

    // updates date at the location header every 1 sec
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
                weatherData.updateWeatherLocation()
                previousHour = hours
            }
        }
    }

    // main body
    ColumnLayout {
        anchors.fill: parent

        // top bar
        LocationHeader {
            id: locationArea
            city: weatherData.weatherLocation["city"]
            country: weatherData.weatherLocation["country"]
            countryCode: weatherData.weatherLocation["countryCode"]
            date: ""

            Layout.topMargin: weatherData.isWeatherDataReady ? 0 : (parent.height - height) / 2
            Behavior on Layout.topMargin {
                NumberAnimation { duration: 500 }
            }
        }

        ForecastView {
            temperature: weatherData.weatherData["temperature"] || 0
            temperatureHigh: weatherData.weatherData["dailyForecastTempHigh"] || 0
            temperatureLow: weatherData.weatherData["dailyForecastTempLow"] || 0
            apparentTemperature: weatherData.weatherData["apparentTemperature"] || 0

            // for weather graph
            points: weatherData.weatherData["dailyForecastTemps"] || []
            pointBottomLabels: weatherData.weatherData["dailyForecastHours"] || []
            pointTopWeatherCodes: weatherData.weatherData["dailyForecastWeatherCodes"] || []

            id: dailyWeatherArea
            opacity: weatherData.isWeatherDataReady ? 1 : 0
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
