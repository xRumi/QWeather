import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

ColumnLayout {
    property var backgroundItem

    id: root
    Layout.alignment: Qt.AlignCenter

    width: 200
    height: 200

    component CardItem: Rectangle {
        property string iconName
        property string middleText
        property string bottomText
        property real absoluteX: card.mapToItem(null, 0, 0).x
        property real absoluteY: card.mapToItem(null, 0, 0).y

        id: card
        color: "transparent"
        border {
            color: AppState.color.gradientBottom
            width: 1.5
        }
        radius: 5

        Layout.maximumHeight: 180
        Layout.minimumHeight: 120
        Layout.fillHeight: true
        Layout.fillWidth: true

        ColumnLayout {
            anchors.centerIn: parent
            anchors.margins: 10

            Image {
                Layout.alignment:  Qt.AlignCenter
                source: "../" + iconName
                sourceSize: Qt.size(40, 40)
            }
            Text {
                text: middleText
                color: AppState.color.text2
                font {
                    pixelSize: 16
                }
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
            }
            Text {
                text: "<b>" + bottomText + "</b>"
                color: AppState.color.text2
                font {
                    pixelSize: 20
                }
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
            }
        }
    }

    Text {
        text: "DETAILS"
        color: AppState.color.text1
        font {
            pixelSize: 16
        }
    }

    GridLayout {
        columns: 3
        Layout.maximumHeight: 300
        Layout.maximumWidth: 350

        CardItem {
            id: temp
            iconName:   AppState.weatherData["apparentTemperature"] <= 15 ?
                            "assets/icons/thermometer-cold-light.svg" :
                        AppState.weatherData["apparentTemperature"] >= 30 ?
                              "assets/icons/thermometer-hot-light.svg" :
                        "assets/icons/thermometer-simple-light.svg"
            middleText: "Feels like"
            bottomText: AppState.weatherData["apparentTemperature"] + "° C"
        }
        CardItem {
            iconName: "assets/icons/wind-light.svg"
            middleText: "Wind"
            bottomText: AppState.weatherData["windSpeed"] + " km/h"
        }
        CardItem {
            iconName: "assets/icons/drop-light.svg"
            middleText: "Humidity"
            bottomText: AppState.weatherData["relativeHumidity"] + " %"
        }
        CardItem {
            iconName: "assets/icons/speedometer-light.svg"
            middleText: "Pressure"
            bottomText: (AppState.weatherData["surfacePressure"] / 10).toFixed(1) + " kPa"
        }
        CardItem {
            iconName: "assets/icons/cloud-rain.svg"
            middleText: "Precipitation"
            bottomText: AppState.weatherData["precipitation"] + " mm"
        }
        CardItem {
            iconName: "assets/icons/thermometer-light.svg"
            middleText: "Dew Point"
            bottomText: AppState.weatherData["dewPoint"] + "° C"
        }
    }
}
