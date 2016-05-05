#include "mainengine.h"
#include <QDebug>

MainEngine::MainEngine()
{

}

void MainEngine::initialize(const QString &qmlPath)
{
    m_source.setUrl(qmlPath);
    load(m_source);
}

void MainEngine::quit()
{
    qApp->quit();
}

void MainEngine::reloadQml()
{
    foreach (QObject * obj, rootObjects()) {

        if(m_nuked.contains(obj)) {
            continue;
        }

    m_nuked.append(obj);
    setObjectOwnership(obj, CppOwnership);
    obj->deleteLater();

    }

    loadData(QByteArray());
    clearComponentCache();
    //qDebug() << "Before reload QML";
    load(m_source);
    //qDebug() << "After reload QML";
}
