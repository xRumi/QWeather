#ifndef RECEIVERTHREAD_H
#define RECEIVERTHREAD_H

#include <QString>
#include <QThread>
#include <QMutex>
#include <QByteArray>
#include <QDebug>

class ReceiverThread : public QThread {
    Q_OBJECT

public:
    ReceiverThread() {
        m_quit = true;
    };
    ~ReceiverThread() {};

    void startReceiver(const QString& portName, int dataSize, int waitTimeout) {
        qDebug() << "startReceiver() called";
        m_mutex.lock();
        m_portName = portName;
        m_dataSize = dataSize;
        m_waitTimeout = waitTimeout;
        m_resetSerial = true;
        if (m_quit) {
            m_quit = false;
            this->start();
        }
        m_mutex.unlock();
    }

signals:
    void request(const QByteArray& res);
    void error(const QString& res);
    void timeout(const QString& res);

private:
    void run() override;

    QMutex m_mutex;
    QString m_portName;
    int m_waitTimeout;
    int m_dataSize;
    bool m_resetSerial;
    bool m_quit;
};

#endif // RECEIVERTHREAD_H
