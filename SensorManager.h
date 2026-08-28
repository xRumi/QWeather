#ifndef SENSORMANAGER_H
#define SENSORMANAGER_H

#include "receiverthread.h"
#include <QQuickItem>
#include <QVariantMap>
#include <QElapsedTimer>
#include <QByteArray>

class SensorManager : public QQuickItem {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QVariantMap sensorData READ sensorData NOTIFY sensorDataChanged)
    Q_PROPERTY(QString sensorStatus READ sensorStatus WRITE setSensorStatus NOTIFY sensorStatusChanged)
    Q_PROPERTY(bool isError READ isError WRITE setIsError NOTIFY isErrorChanged)

public:
    SensorManager();

    QVariantMap sensorData() const { return m_sensorData; }
    bool isError() const { return m_isError; }
    QString sensorStatus() const { return m_sensorStatus; }

    void updateSensorData(const QByteArray& data);

public slots:
    void restart() {
        #ifdef Q_OS_ANDROID
        setSensorStatus("Sensor Reading Disabled for Android");
        setIsError(true);
        #else
        elapsedTimer.start();
        receiver.startReceiver("/dev/ttyUSB0", 5, 2000);
        setSensorStatus("Connecting..");
        setIsError(true);
        m_sensorData.clear();
        #endif
    }
    void setIsError(bool ready) {
        if (m_isError != ready) {
            m_isError = ready;
            emit isErrorChanged();
        }
    }
    void setSensorStatus(const QString& status) {
        if (m_sensorStatus != status) {
            m_sensorStatus = status;
            emit sensorStatusChanged();
        }
    }

signals:
    void sensorDataChanged();
    void sensorStatusChanged();
    void isErrorChanged();

private:
    QVariantMap m_sensorData;
    bool m_isError;
    QString m_sensorStatus;
    ReceiverThread receiver;
    QElapsedTimer elapsedTimer;
};

#endif // SENSORMANAGER_H
