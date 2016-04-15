#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include "carview.h"
#include "carblock.h"
#include "sqldatabase.h"
#include "fileio.h"
#include "imageprovider.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<CarBlock>();
    qmlRegisterType<BookingInfo>();
    qmlRegisterType<FileIO>();
    qmlRegisterType<SingleCode>();
    qmlRegisterType<SqlDatabase>("sigma.sql", 1, 0, "SqlDatabase");

    CarView cv;
    CarBlock cb;
    FileIO fileIO;

    auto root_context = engine.rootContext();
    root_context->setContextProperty("carViewClass", &cv);
    root_context->setContextProperty("carBlockClass", &cb);
    root_context->setContextProperty("fileio", &fileIO);

    engine.addImageProvider(QLatin1String("cImages"), new ImageProvider);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

