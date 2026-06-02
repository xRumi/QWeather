import QtQuick
import QtQuick.Layouts

ColumnLayout {
    property real temperature: 0
    property real temperatureHigh: 0
    property real temperatureLow: 0
    property real apparentTemperature: 0

    property var points: []
    property string pointSuffix: "°"
    property var pointBottomLabels: []
    property var pointTopWeatherCodes: []

    Behavior on temperature { NumberAnimation { duration: 800 } }
    Behavior on temperatureHigh { NumberAnimation { duration: 800 } }
    Behavior on temperatureLow { NumberAnimation { duration: 800 } }
    Behavior on apparentTemperature { NumberAnimation { duration: 800 } }

    id: root

    ColumnLayout {
        // Layout.alignment: Qt.AlignCenter

        Row {
            spacing: 15

            Image {
                source: "../" + AppTheme.weatherIcon
                sourceSize: Qt.size(64, 64)
            }
            Text {
                text: AppTheme.condition
                color: AppTheme.color.text2
                font {
                    pixelSize: 35
                    weight: 300
                }
            }
        }
        Row {
            spacing: 50
            Text {
                text: root.temperature.toFixed(1) + "°"
                color: AppTheme.color.text1
                font {
                    pixelSize: 110
                    weight: 300
                }
            }
            ColumnLayout {
                Text {
                    Layout.topMargin: 60
                    text: root.temperatureHigh.toFixed(1) + "° C"
                    color: AppTheme.color.text3
                    font {
                        pixelSize: 18
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: AppTheme.color.text3
                }

                Text {
                    text: root.temperatureLow.toFixed(1) + "° C"
                    color: AppTheme.color.text3
                    font {
                        pixelSize: 18
                    }
                }
            }
        }
        Text {
            Layout.topMargin: -20
            text: "Feels like <b>" + apparentTemperature.toFixed(1) + "°</b> C"
            color: AppTheme.color.text3
            font {
                pixelSize: 18
            }
        }
    }
    WeatherGraph {
        points: root.points
        pointSuffix: root.pointSuffix
        pointBottomLabels: root.pointBottomLabels
        pointTopWeatherCodes: root.pointTopWeatherCodes

        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.topMargin: 50
        // Layout.maximumHeight: 300
    }
}
