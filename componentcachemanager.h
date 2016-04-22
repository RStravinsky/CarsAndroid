#ifndef COMPONENTCACHEMANAGER_H
#define COMPONENTCACHEMANAGER_H

#include <QObject>
#include <QQmlApplicationEngine>

class ComponentCacheManager : public QObject
{
    Q_OBJECT
public:
    explicit ComponentCacheManager(QQmlApplicationEngine * engine, QObject *parent = 0) : m_engine(engine), QObject(parent) {}

    Q_INVOKABLE void clear() { m_engine->clearComponentCache(); }

signals:

public slots:

private:
    QQmlApplicationEngine * m_engine;
};

#endif // COMPONENTCACHEMANAGER_H
