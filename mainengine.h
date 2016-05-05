#ifndef MAINENGINE_H
#define MAINENGINE_H

#include <QtGui/QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQmlContext>


class MainEngine : public QQmlApplicationEngine
{
    Q_OBJECT

public:
    QUrl m_source;
    QList<QObject *> m_nuked;

    explicit MainEngine();
    void initialize(const QString &qmlPath = QString());

    Q_INVOKABLE void quit();

public slots:
    void reloadQml();


};

#endif // MAINENGINE_H
