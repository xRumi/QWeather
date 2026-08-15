#ifndef WEATHERDATA_H
#define WEATHERDATA_H

#include <QQuickItem>
#include <QNetworkAccessManager>
#include <QSettings>
#include <QVariantMap>

class WeatherData : public QQuickItem {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QVariantMap weatherLocation READ weatherLocation NOTIFY weatherLocationChanged)
    Q_PROPERTY(QVariantMap weatherData READ weatherData NOTIFY weatherDataChanged)

    Q_PROPERTY(bool isWeatherDataReady READ isWeatherDataReady WRITE setIsWeatherDataReady NOTIFY isWeatherDataReadyChanged)
public:
    WeatherData();

    QVariantMap weatherLocation() { return m_weatherLocation; }
    QVariantMap weatherData() { return m_weatherData; }

    bool isWeatherDataReady() { return m_isWeatherDataReady; }

public slots:
    void updateWeatherLocation();
    void updateWeatherData();
    void setIsWeatherDataReady(bool ready) {
        if (ready != m_isWeatherDataReady) {
            m_isWeatherDataReady = ready;
            emit isWeatherDataReadyChanged();
        }
    }

signals:
    void weatherLocationChanged();
    void weatherDataChanged();
    void isWeatherDataReadyChanged();

private:
    QSettings m_settings;
    QNetworkAccessManager m_networkManager;

    QVariantMap m_weatherLocation;
    QVariantMap m_weatherData;

    bool m_isWeatherDataReady = false;
};

#endif // WEATHERDATA_H
