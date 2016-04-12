#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
//#include <QQuickWindow>
//#include <QQuickView>
//#include <QGuiApplication>
//#include <QQmlEngine>
//#include <QQmlContext>
//#include <QQmlComponent>
//#include <QObject>
//#include <QFont>
#include "carview.h"
#include "carblock.h"

int main(int argc, char *argv[])
{


    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    auto root_context = engine.rootContext();
    qmlRegisterType<CarBlock>();
    qmlRegisterType<BookingInfo>();;
    CarView cv;
    CarBlock cb;

    root_context->setContextProperty("carViewClass", &cv);
    root_context->setContextProperty("carBlockClass", &cb);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
