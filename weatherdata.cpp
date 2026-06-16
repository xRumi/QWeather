#include "weatherdata.h"
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonValue>
#include <QSettings>
#include <QVariantMap>
#include <QJsonObject>
#include <QTimer>
#include <QJsonArray>
#include <QDateTime>
#include <QDate>

#define MIN(a, b) a > b ? b : a
#define MAX(a, b) a > b ? a : b

QJsonDocument parseJsonFromReply(QNetworkReply* reply, bool& success) {
    if (reply->error() != QNetworkReply::NoError) {
        qDebug() << "Network reply error: " << reply->errorString();
        success = false;
        return QJsonDocument{};
    }
    QJsonParseError resultJsonErr{};
    QJsonDocument resultJson = QJsonDocument::fromJson(reply->readAll(), &resultJsonErr);
    if (resultJsonErr.error != QJsonParseError::NoError) {
        qDebug() << "Json parse error: " << resultJsonErr.errorString();
        success = false;
        return QJsonDocument{};
    }
    success = true;
    return resultJson;
}

WeatherData::WeatherData() : m_settings("yanQt", "QWeather") {
    m_weatherLocation = m_settings.value("lastWeatherLocation").toJsonObject().toVariantMap();
}

void WeatherData::updateWeatherLocation() {
    QNetworkRequest req{ QUrl("http://ip-api.com/json/") };
    req.setTransferTimeout(10000);

    QNetworkReply* reply = m_networkManager.get(req);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        bool success = false;
        QJsonDocument resultJson = parseJsonFromReply(reply, success);
        reply->deleteLater();
        if (!success) {
            QTimer::singleShot(2000, this, [this]() {
                qDebug() << "Retrying... updateWeatherLocation()";
                updateWeatherLocation();
            });
            return;
        }
        m_weatherLocation["country"] = resultJson["country"].toString();
        m_weatherLocation["countryCode"] = resultJson["countryCode"].toString();
        m_weatherLocation["city"] = resultJson["city"].toString();
        m_weatherLocation["latitude"] = resultJson["lat"].toDouble();
        m_weatherLocation["longitude"] = resultJson["lon"].toDouble();

        m_settings.setValue("lastWeatherLocation", m_weatherLocation);

        emit weatherLocationChanged();

        qDebug() << "lat: " << m_weatherLocation["latitude"].toString() << "lon: " << m_weatherLocation["longitude"].toString();
        qDebug() << "updateLocation() done";
    });
}

void WeatherData::updateWeatherData() {
    QString urlStr = QString("https://api.open-meteo.com/v1/forecast?latitude=%1&longitude=%2&hourly=temperature_2m,rain,weather_code&current=temperature_2m,relative_humidity_2m,apparent_temperature,wind_speed_10m,weather_code,is_day,rain,cloud_cover,surface_pressure")
                         .arg(m_weatherLocation["latitude"].toString(), m_weatherLocation["longitude"].toString());
    QNetworkRequest req{ QUrl(urlStr) };
    req.setTransferTimeout(10000);

    QNetworkReply* reply = m_networkManager.get(req);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        bool success = false;
        QJsonDocument resultJson = parseJsonFromReply(reply, success);
        reply->deleteLater();
        if (!success) {
            QTimer::singleShot(2000, this, [this]() {
                qDebug() << "Retrying... updateWeatherData()";
                updateWeatherData();
            });
            return;
        }
        QJsonValue current = resultJson["current"];
        m_weatherData["weatherTime"] = current["time"].toString();
        m_weatherData["temperature"] = current["temperature_2m"].toDouble();
        m_weatherData["relativeHumidity"] = current["relative_humidity_2m"].toDouble();
        m_weatherData["apparentTemperature"] = current["apparent_temperature"].toDouble();
        m_weatherData["windSpeed"] = current["wind_speed_10m"].toDouble();
        m_weatherData["weatherCode"] = current["weather_code"].toInt();
        m_weatherData["isNight"] = current["is_day"].toInt() == 0;
        m_weatherData["rain"] = current["rain"].toDouble();
        m_weatherData["cloudCover"] = current["cloud_cover"].toDouble();
        m_weatherData["surfacePressure"] = current["surface_pressure"].toDouble();

        QJsonValue hourly = resultJson["hourly"];
        QJsonArray times = hourly["time"].toArray(),
            temps = hourly["temperature_2m"].toArray(),
            weatherCodes = hourly["weather_code"].toArray();

        int dailyForecastHourLimit = 50;
        double dailyForecastTempHigh = -1000, dailyForecastTempLow = 1000;
        QJsonArray dailyForecastHours{};
        QJsonArray dailyForecastTemps{};
        QJsonArray dailyForecastWeatherCodes;
        for (int i = 0; i < times.size(); i++) {
            QDateTime time = QDateTime::fromString(times[i].toString() + "Z", Qt::ISODate);
            time = time.toLocalTime();
            QDateTime current = QDateTime::currentDateTime();

            // skip previous months
            if (time.date().month() < current.date().month()) continue;
            // skip previous days of current month
            if (time.date().month() == current.date().month() && time.date().day() < current.date().day()) continue;

            if (time.date().day() == current.date().day()) {
                dailyForecastTempHigh = MAX(dailyForecastTempHigh, temps[i].toDouble());
                dailyForecastTempLow = MIN(dailyForecastTempLow, temps[i].toDouble());

                // skip previous hours
                if (time.time().hour() < current.time().hour()) continue;
            }

            // daily forecasts
            if ((time.time().hour() == current.time().hour() || (time.time().hour() % 3 == 0)) && dailyForecastHours.size() < dailyForecastHourLimit) {
                int hour = time.time().hour();
                dailyForecastHours << QString::number((hour % 12) ? (hour % 12) : 12) + (hour >= 12 ? "pm" : "am");
                dailyForecastTemps << temps[i].toDouble();
                dailyForecastWeatherCodes << weatherCodes[i].toInt();
            }
        }

        m_weatherData["dailyForecastTempHigh"] = dailyForecastTempHigh;
        m_weatherData["dailyForecastTempLow"] = dailyForecastTempLow;
        m_weatherData["dailyForecastHours"] = dailyForecastHours;
        m_weatherData["dailyForecastTemps"] = dailyForecastTemps;
        m_weatherData["dailyForecastWeatherCodes"] = dailyForecastWeatherCodes;

        setIsWeatherDataReady(true);
        emit weatherDataChanged();

        qDebug() << "updateWeatherData() done";
    });
}