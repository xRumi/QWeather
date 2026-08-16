#include "SensorManager.h"
#include "receiverthread.h"
#include <QRandomGenerator>
#include <QVariantMap>
#include <QVariantList>
#include <QElapsedTimer>

SensorManager::SensorManager() {
    restart();

    connect(&receiver, &ReceiverThread::error, this, [this](const QString& res) {
        setSensorStatus(res);
        setIsError(true);
    });
    connect(&receiver, &ReceiverThread::timeout, this, [this](const QString& res) {
        setSensorStatus("Sensor disconnected");
        setIsError(true);
    });
    connect(&receiver, &ReceiverThread::request, this, [this](const QByteArray& res) {
        int8_t checksum = res[0] + res[1] + res[2] + res[3];

        if (checksum == res[4] && checksum != 0) {
            updateSensorData(res);
            setSensorStatus("Sensor connected");
            setIsError(false);
        } else {
            setSensorStatus("Invalid sensor data checksum");
            setIsError(true);
            qDebug() << "checksum error";

            qDebug() << QString::number((uint8_t)res[0], 16) << QString::number((uint8_t)res[1], 16) << QString::number((uint8_t)res[2], 16) << QString::number((uint8_t)res[3], 16) << QString::number((uint8_t)res[4], 16);
            qDebug() << "checksum = " << QString::number((uint8_t)checksum, 16);

        }
    });
}

void SensorManager::updateSensorData(const QByteArray& data) {

    QVariantList humidities = m_sensorData["humidities"].toList();
    QVariantList temps = m_sensorData["temps"].toList();
    QVariantList times = m_sensorData["times"].toList();

    if (temps.count() > 50) {
        temps.pop_front();
        humidities.pop_front();
        times.pop_front();
    }

    float divider = std::pow(10, QString::number(data[1]).length());
    humidities << data[0] + data[1] / divider;

    divider = std::pow(10, QString::number(data[3]).length());
    temps << data[2] + data[3] / divider;

    int time = elapsedTimer.elapsed() / 1000;
    times << QString::number(time) + "s";

    m_sensorData["humidities"] = humidities;
    m_sensorData["temps"] = temps;
    m_sensorData["times"] = times;

    emit sensorDataChanged();
}