import QtQuick
import QtQuick.Layouts

ColumnLayout {
    property var weatherData
    property real temperature: weatherData["temperature"] || 0
    property real temperatureHigh: weatherData["dailyForecastTempHigh"] || 0
    property real temperatureLow: weatherData["dailyForecastTempLow"] || 0
    property real apparentTemperature: weatherData["apparentTemperature"] || 0

    Behavior on temperature { NumberAnimation { duration: 800 } }
    Behavior on temperatureHigh { NumberAnimation { duration: 800 } }
    Behavior on temperatureLow { NumberAnimation { duration: 800 } }
    Behavior on apparentTemperature { NumberAnimation { duration: 800 } }

    id: root

    ColumnLayout {
        Layout.alignment: Qt.AlignCenter

        Row {
            spacing: 15

            Image {
                source: "../" + AppState.weatherIcon
                sourceSize: Qt.size(64, 64)
            }
            Text {
                height: 50
                text: AppState.condition
                color: AppState.color.text2
                font {
                    pixelSize: 35
                    weight: 300
                }
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
        Row {
            spacing: 50
            Text {
                text: root.temperature.toFixed(1) + "°"
                color: AppState.color.text1
                font {
                    pixelSize: 110
                    weight: 300
                }
            }
            ColumnLayout {
                Text {
                    Layout.topMargin: 60
                    text: root.temperatureHigh.toFixed(1) + "° C"
                    color: AppState.color.text3
                    font {
                        pixelSize: 18
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: AppState.color.text3
                }

                Text {
                    text: root.temperatureLow.toFixed(1) + "° C"
                    color: AppState.color.text3
                    font {
                        pixelSize: 18
                    }
                }
            }
        }
        Text {
            Layout.topMargin: -20
            text: "Feels like <b>" + apparentTemperature.toFixed(1) + "°</b> C"
            color: AppState.color.text3
            font {
                pixelSize: 18
            }
        }
    }
    WeatherGraph {
        // for weather graph
        points: root.weatherData["dailyForecastTemps"] || []
        pointSuffix: "°"
        pointBottomLabels: root.weatherData["dailyForecastHours"] || []
        pointTopWeatherCodes: root.weatherData["dailyForecastWeatherCodes"] || []

        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.topMargin: 50
        Layout.maximumHeight: 300
    }
}
