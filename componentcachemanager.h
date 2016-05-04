#ifndef COMPONENTCACHEMANAGER_H
#define COMPONENTCACHEMANAGER_H

#include <QObject>
#include <QQmlApplicationEngine>
#include "mainengine.h"

class ComponentCacheManager : public QObject
{
    Q_OBJECT
public:
    explicit ComponentCacheManager(MainEngine * engine, QObject *parent = 0) : m_engine(engine), QObject(parent) {}

    Q_INVOKABLE void reload() { m_engine->reloadQml(); }

signals:

public slots:

private:
    MainEngine * m_engine;
};

#endif // COMPONENTCACHEMANAGER_H
