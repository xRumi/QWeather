#ifndef SENSORMANAGER_H
#define SENSORMANAGER_H

#include <QQuickItem>
#include <QVariantMap>

class SensorManager : public QQuickItem {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QVariantMap sensorData READ sensorData NOTIFY sensorDataChanged)
    Q_PROPERTY(bool isReady READ isReady WRITE setIsReady NOTIFY isReadyChanged)

public:
    SensorManager();

    QVariantMap sensorData() const { return m_sensorData; };
    bool isReady() const { return m_isReady; }

public slots:
    void updateSensorData();
    void setIsReady(bool ready) {
        if (m_isReady != ready) {
            m_isReady = ready;
            emit isReadyChanged();
        }
    }

signals:
    void sensorDataChanged();
    void isReadyChanged();

private:
    QVariantMap m_sensorData;
    bool m_isReady;

};

#endif // SENSORMANAGER_H
