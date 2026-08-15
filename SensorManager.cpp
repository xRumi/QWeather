#include "SensorManager.h"
#include <QRandomGenerator>
#include <QVariantMap>
#include <QVariantList>
#include <QString>


SensorManager::SensorManager() {
    setIsReady(true);
}

void SensorManager::updateSensorData() {
    QVariantList temps = m_sensorData["temps"].toList();
    QVariantList humidities = m_sensorData["humidities"].toList();
    QVariantList times = m_sensorData["times"].toList();

    if (temps.count() > 50) {
        temps.pop_front();
        humidities.pop_front();
        times.pop_front();
    }
    int previousTempsCount = temps.count();

    static int sec = 0;
    temps << QRandomGenerator::global()->bounded(30, 40);
    humidities << QRandomGenerator::global()->bounded(80, 100);
    times << QString::number(sec) + "s";
    sec += 1;

    m_sensorData["temps"] = temps;
    m_sensorData["humidities"] = humidities;
    m_sensorData["times"] = times;

    if (previousTempsCount != temps.count()) emit sensorDataChanged();
}