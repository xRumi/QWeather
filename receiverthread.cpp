#include "receiverthread.h"
#include <QString>
#include <QThread>
#include <QMutex>
#include <QByteArray>
#include <QSerialPort>
#include <QDebug>

void ReceiverThread::run() {
    qDebug() << "run() called";

    QSerialPort serial;

    while (1) {
        m_mutex.lock();
        QString portName = m_portName;
        int dataSize = m_dataSize;
        int waitTimeout = m_waitTimeout;

        if (portName.isEmpty()) {
            emit error("portName not set");
            m_quit = true;
        }

        if (m_resetSerial) {
            m_resetSerial = false;
            serial.close();
            serial.setBaudRate(QSerialPort::Baud1200);
            serial.setStopBits(QSerialPort::OneStop);
            serial.setPortName(portName);

            if (!serial.open(QIODevice::ReadOnly)) {
                emit error(QString("Can not open %1, error = %2").arg(portName).arg(serial.error()));
                m_quit = true;
            }
        }
        bool quit = m_quit;

        m_mutex.unlock();

        if (quit) break;

        if (serial.waitForReadyRead(waitTimeout)) {
            QByteArray res;
            do {
                res += serial.readAll();
                if (res.size() >= dataSize) {
                    emit request(res);
                    break;
                }
            } while (serial.waitForReadyRead(20));
            serial.clear();
            while (serial.waitForReadyRead(20)) {
                serial.readAll();
                qDebug() << "extra bytes somehow!!";
            }
        } else emit timeout("Receiver Timeout, retrying");
    }
}
