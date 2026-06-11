import QtQuick

pragma Singleton

Item {
    id: root
    property var weatherData
    property int weatherCode: weatherData["weatherCode"] || 0
    property bool isNight: weatherData["isNight"] || false
    property var condition: weatherCodeDecode[weatherCode]?.condition || "Unknown"
    property var color: colors[weatherCodeDecode[weatherCode]?.color || 0]
    property var weatherIcon: weatherCodeDecode[weatherCode]?.icon

    // for accessing weatherIcons from javascript as failed to do so directly
    property int tempWeatherCode: 0
    property var tempWeatherIcon: weatherCodeDecode[tempWeatherCode]?.icon

    property var weatherCodeDecode: {
        0:  { condition: "Clear Sky",           color: 0,  icon: isNight ? "assets/icons/moon.svg" : "assets/icons/sun.svg" },
        1:  { condition: "Mainly Clear",        color: 0,  icon: isNight ? "assets/icons/cloud-moon.svg" : "assets/icons/sun-dim.svg" },
        2:  { condition: "Partly Cloudy",       color: 2,  icon: "assets/icons/cloud.svg" },
        3:  { condition: "Overcast",            color: 2,  icon: "assets/icons/cloud.svg" },
        45: { condition: "Fog",                 color: 45, icon: "assets/icons/cloud-fog.svg" },
        48: { condition: "Rime Fog",            color: 46, icon: "assets/icons/cloud-fog.svg" },
        51: { condition: "Light Drizzle",       color: 2,  icon: "assets/icons/drop-light.svg" },
        53: { condition: "Moderate Drizzle",    color: 2,  icon: "assets/icons/drop-light.svg" },
        55: { condition: "Dense Drizzle",       color: 2,  icon: "assets/icons/drop-light.svg" },
        56: { condition: "Light Frz. Drizzle",  color: 0 },
        57: { condition: "Dense Frz. Drizzle",  color: 0 },
        61: { condition: "Slight Rain",         color: 0,  icon: "assets/icons/cloud-rain.svg" },
        63: { condition: "Moderate Rain",       color: 0,  icon: "assets/icons/cloud-rain.svg" },
        65: { condition: "Heavy Rain",          color: 0,  icon: "assets/icons/cloud-rain.svg" },
        66: { condition: "Light Frz. Rain",     color: 0 },
        67: { condition: "Heavy Frz. Rain",     color: 0 },
        71: { condition: "Slight Snowfall",     color: 46 },
        73: { condition: "Moderate Snowfall",   color: 46 },
        75: { condition: "Heavy Snowfall",      color: 46 },
        77: { condition: "Snow Grains",         color: 46 },
        80: { condition: "Slight Rain Shower",  color: 0 },
        81: { condition: "Moderate Rain Shower",color: 2 },
        82: { condition: "Violent Rain Shower", color: 2 },
        85: { condition: "Slight Snow Shower",  color: 46 },
        86: { condition: "Heavy Snow Shower",   color: 46 },
        95: { condition: "Thunderstorm",        color: 95,  icon: "assets/icons/cloud-lightning.svg" },
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
        },
        2: {
            gradientTop: isNight ? "#112159" : "#5493b2",
            gradientBottom: isNight ? "#9561a2" : "#a6bdcb",
            text1: "#f6fdfe",
            text2: "#fcfcfc",
            text3: isNight ? "#e9e1f7" : "#afe1f3",
        },
        45: {
            gradientTop: isNight ? "#112159" : "#b68eb6",
            gradientBottom: isNight ? "#9561a2" : "#5e5e89",
            text1: "#f6fdfe",
            text2: "#fcfcfc",
            text3: isNight ? "#e9e1f7" : "#afe1f3",
        },
        46: {
            gradientTop: isNight ? "#112159" : "#e2e5f2",
            gradientBottom: isNight ? "#9561a2" : "#adb2be",
            text1: "#f6fdfe",
            text2: "#fcfcfc",
            text3: isNight ? "#e9e1f7" : "#afe1f3",
        },
        95: {
            gradientTop: isNight ? "#9485e6" : "#ffd99b",
            gradientBottom: isNight ? "#2e2c9a" : "#a24a55",
            text1: "#f6fdfe",
            text2: "#fcfcfc",
            text3: "#fcfcfc",
        }
    }
}