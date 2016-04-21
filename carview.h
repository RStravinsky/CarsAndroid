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
    Q_PROPERTY(bool isBusy READ getIsBusy WRITE setIsBusy NOTIFY onIsBusyChanged)

public:
    explicit CarView(QObject *parent = 0);

    Q_INVOKABLE QQmlListProperty<CarBlock> getCarList() {return QQmlListProperty<CarBlock>(this, nullptr, &carListCount, &carListAt);}
    static int carListCount(QQmlListProperty<CarBlock>*list);
    static CarBlock* carListAt(QQmlListProperty<CarBlock> *list, int i);

    Q_INVOKABLE const bool getIsBusy() {return m_isBusy;}
    void setIsBusy(bool isBusy);

signals:
    void onCarListChanged(QQmlListProperty<CarBlock>);
    void onIsBusyChanged(bool);

public slots:
    QString generateCode();
    void setCarList();
    void clearCarList();
    int findCarListIndex(QString searchField);

private:
    QList<CarBlock*> m_carList;
    QSqlQueryModel m_carModel;
    bool m_isBusy{false};

    void setBusy(bool isBusy);
};

#endif // CARVIEW_H
