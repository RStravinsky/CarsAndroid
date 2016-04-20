#ifndef CARVIEW_H
#define CARVIEW_H

#include <QObject>
#include <QQmlListProperty>
#include <QtSql>
#include <memory>
#include <string>
#include <ctime>
#include <QDebug>
#include <QThread>
#include "carblock.h"
#include "sqldatabase.h"
#include "imageprovider.h"

class CarBlock;

class CarView : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<CarBlock> carList READ getCarList NOTIFY onCarListChanged)


public:
    explicit CarView(QObject *parent = 0);

    Q_INVOKABLE QQmlListProperty<CarBlock> getCarList() {return QQmlListProperty<CarBlock>(this, nullptr, &carListCount, &carListAt);}
    static int carListCount(QQmlListProperty<CarBlock>*list);
    static CarBlock* carListAt(QQmlListProperty<CarBlock> *list, int i);

signals:
    void onCarListChanged(QQmlListProperty<CarBlock>);

public slots:
    QString generateCode();
    void setCarList();
    void clearCarList();

private:
    QList<CarBlock*> m_carList;
    QSqlQueryModel m_carModel;
};

#endif // CARVIEW_H
