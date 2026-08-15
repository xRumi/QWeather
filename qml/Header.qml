import QtQuick
import QtQuick.Layouts

ColumnLayout {
    required property var weatherLocation

    property string city: weatherLocation["city"] || "Weather App"
    property string country: weatherLocation["country"] || "yanQt"
    property string countryCode: weatherLocation["countryCode"] || "yq"
    property string date: ""

    id: root

    Text {
        Layout.fillWidth: true
        text: root.city
        color: AppState.color.text2
        font {
            pixelSize: 25
            letterSpacing: 1.2
            weight: 400
        }
        horizontalAlignment: Text.AlignHCenter
    }
    Text {
        Layout.fillWidth: true
        Layout.topMargin: -5
        text: root.date
        color: AppState.color.text3
        font {
            pixelSize: 17
            weight: 400
        }
        horizontalAlignment: Text.AlignHCenter
    }
}
