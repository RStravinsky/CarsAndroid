#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QScreen>
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

    //static qreal refDpi = 216.;
    //static qreal refHeight = 1776.;
    //static qreal refWidth = 1080.;
    static qreal ppi = QGuiApplication::primaryScreen()->physicalDotsPerInch() * QGuiApplication::primaryScreen()->devicePixelRatio();
    static qreal dpi = qApp->primaryScreen()->logicalDotsPerInch();
    static qreal imageRatio = dpi/144.;
    static qreal ratio = 144./dpi;

    ppi *= ratio;

    CarView cv;
    CarBlock cb;
    FileIO fileIO;

    auto root_context = engine.rootContext();
    root_context->setContextProperty("carViewClass", &cv);
    root_context->setContextProperty("carBlockClass", &cb);
    root_context->setContextProperty("fileio", &fileIO);
    root_context->setContextProperty("ppi", ppi);
    root_context->setContextProperty("dpi", dpi);
    root_context->setContextProperty("ratio", ratio);
    root_context->setContextProperty("imageRatio", imageRatio);

    engine.addImageProvider(QLatin1String("cImages"), new ImageProvider);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

