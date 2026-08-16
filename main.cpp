#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <iostream>
#include "receiverthread.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed, &app, []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.loadFromModule("QWeather", "Main");

    std::cout << "Hello People of somewhere!!" << std::endl;
    qDebug()  << "test qDebug";

    return app.exec();
}
