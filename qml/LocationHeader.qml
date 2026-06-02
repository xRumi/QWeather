import QtQuick
import QtQuick.Layouts

ColumnLayout {
    property string city: "Weather App"
    property string country: ""
    property string countryCode: ""
    property string date: ""

    id: root

    Text {
        Layout.fillWidth: true
        text: root.city
        color: AppTheme.color.text2
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
        color: AppTheme.color.text3
        font {
            pixelSize: 17
            weight: 400
        }
        horizontalAlignment: Text.AlignHCenter
    }
}
