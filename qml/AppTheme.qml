import QtQuick

pragma Singleton

Item {
    id: root
    property int weatherCode: 0
    property bool isNight: false
    property var condition: weatherCodeDecode[weatherCode]?.condition || "Unknown"
    property var color: colors[weatherCodeDecode[weatherCode]?.color || 0]
    property var weatherIcon: weatherCodeDecode[weatherCode]?.icon

    property int tempWeatherCode: 0
    property var tempWeatherIcon: weatherCodeDecode[tempWeatherCode]?.icon

    property var weatherCodeDecode: {
        0:  { condition: "Clear Sky",           color: 0, icon: root.isNight ? "assets/icons/moon.svg" : "assets/icons/sun.svg" },
        1:  { condition: "Mainly Clear",        color: 0, icon: root.isNight ? "assets/icons/moon.svg" : "assets/icons/sun-dim.svg" },
        2:  { condition: "Partly Cloudy",       color: 0, icon: root.isNight ? "assets/icons/cloud-moon.svg" : "assets/icons/cloud-sun.svg" },
        3:  { condition: "Overcast",            color: 0, icon: "assets/icons/cloud.svg" },
        45: { condition: "Fog",                 color: 0, icon: "assets/icons/cloud-fog.svg" },
        48: { condition: "Rime Fog",            color: 0 },
        51: { condition: "Light Drizzle",       color: 0 },
        53: { condition: "Moderate Drizzle",    color: 0 },
        55: { condition: "Dense Drizzle",       color: 0 },
        56: { condition: "Light Frz. Drizzle",  color: 0 },
        57: { condition: "Dense Frz. Drizzle",  color: 0 },
        61: { condition: "Slight Rain",         color: 0, icon: "assets/icons/cloud-rain.svg" },
        63: { condition: "Moderate Rain",       color: 0, icon: "assets/icons/cloud-rain.svg" },
        65: { condition: "Heavy Rain",          color: 0, icon: "assets/icons/cloud-rain.svg" },
        66: { condition: "Light Frz. Rain",     color: 0 },
        67: { condition: "Heavy Frz. Rain",     color: 0 },
        71: { condition: "Slight Snowfall",     color: 0 },
        73: { condition: "Moderate Snowfall",   color: 0 },
        75: { condition: "Heavy Snowfall",      color: 0 },
        77: { condition: "Snow Grains",         color: 0 },
        80: { condition: "Slight Rain Shower",  color: 0 },
        81: { condition: "Moderate Rain Shower",color: 0 },
        82: { condition: "Violent Rain Shower", color: 0 },
        85: { condition: "Slight Snow Shower",  color: 0 },
        86: { condition: "Heavy Snow Shower",   color: 0 },
        95: { condition: "Thunderstorm",        color: 0, icon: "assets/icons/cloud-lightning.svg" },
        96: { condition: "T-Storm Slight Hail", color: 0 },
        99: { condition: "T-Storm Heavy Hail",  color: 0 },
    }
    readonly property var colors: {
        0: {
            gradientTop: isNight ? "#112159" : "#52a3da",
            gradientBottom: isNight ? "#9561a2" : "#73badd",
            text1: "#f6fdfe",
            text2: "#fcfcfc",
            text3: isNight ? "#e9e1f7" : "#afe1f3",
        }
    }
}