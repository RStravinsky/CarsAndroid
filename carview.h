#ifndef CARVIEW_H
#define CARVIEW_H

#include <QObject>
#include <QQmlListProperty>
#include <QtSql>
#include <memory>
#include "carblock.h"
#include "database.h"

class CarBlock;

class CarView : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<CarBlock> carList READ getCarList NOTIFY onCarListChanged)


private:
    QList<CarBlock*> m_carList;
    QSqlQueryModel m_carModel;

public:
    explicit CarView(QObject *parent = 0);

    Q_INVOKABLE QQmlListProperty<CarBlock> getCarList() {return QQmlListProperty<CarBlock>(this, nullptr, &carListCount, &carListAt);}
    Q_INVOKABLE void setCarList();
    static int carListCount(QQmlListProperty<CarBlock>*list);
    static CarBlock* carListAt(QQmlListProperty<CarBlock> *list, int i);

signals:
    void onCarListChanged(QQmlListProperty<CarBlock>);

public slots:
};

#endif // CARVIEW_H
