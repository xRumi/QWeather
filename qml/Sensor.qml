import QtQuick
import QtQuick.Layouts
import QWeather

ColumnLayout {
    SensorManager {
        id: sensorManager
    }
    Timer {
        running: sensorManager.isError
        repeat: true
        triggeredOnStart: false
        interval: 2000

        onTriggered: {
            sensorManager.restart()
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
        ySuffix: "%"
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
        text: sensorManager.sensorStatus
        color: sensorManager.isError ? "red" : AppState.color.text3
        font.pixelSize: 14
        Layout.alignment: Qt.AlignHCenter
    }
}
