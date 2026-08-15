import QtQuick
import QtQuick.Layouts
import QWeather

ColumnLayout {
    SensorManager {
        id: sensorManager
    }

    Timer {
        interval: 1 * 1000
        repeat: true
        triggeredOnStart: true
        running: true

        onTriggered: {
            sensorManager.updateSensorData()
        }
    }

    Text {
        text: "TEMPERATURE"
        color: AppState.color.text1
        font {
            pixelSize: 16
        }
        horizontalAlignment: Text.AlignRight

        Layout.topMargin: 30
        Layout.fillWidth: true
        Layout.rightMargin: 10
    }
    WeatherGraph {
        // weather graph showing sensor data visually
        yS: sensorManager.sensorData["temps"] || []
        xS: sensorManager.sensorData["times"] || []
        ySuffix: "°"
        weatherCodes: []
        perXWidth: 50
        minYsCount: xS.length
        outerCircleMaxRadii: 0

        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.maximumHeight: 250

        contentX: contentWidth - width
    }

    Text {
        text: "RELATIVE HUMIDITIY"
        color: AppState.color.text1
        font {
            pixelSize: 16
        }
        horizontalAlignment: Text.AlignRight

        Layout.topMargin: 50
        Layout.fillWidth: true
        Layout.rightMargin: 10
    }
    WeatherGraph {
        // weather graph showing sensor data visually
        yS: sensorManager.sensorData["humidities"] || []
        xS: sensorManager.sensorData["times"] || []
        ySuffix: "°"
        weatherCodes: []
        perXWidth: 50
        minYsCount: xS.length
        outerCircleMaxRadii: 0

        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.maximumHeight: 250

        contentX: contentWidth - width
    }

    Text {
        text: sensorManager.isReady ? "Sensor Connected" : "Sensor Disconnected"
        color: sensorManager.isReady ? "green" : "red"
        font {
            pixelSize: 16
        }

        Layout.alignment: Qt.AlignCenter
    }
}
