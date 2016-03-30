#ifndef CARBLOCK_H
#define CARBLOCK_H

#include <QObject>
#include <QtSql>
#include <QQmlListProperty>
#include "bookinginfo.h"

class BookingInfo;

class CarBlock : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ getId CONSTANT)
    Q_PROPERTY(QString brand READ getBrand CONSTANT)
    Q_PROPERTY(QString model READ getModel CONSTANT)
    Q_PROPERTY(QString licensePlate READ getLicensePlate CONSTANT)
    Q_PROPERTY(bool status READ getStatus CONSTANT)
    Q_PROPERTY(QString photoPath READ getPhotoPath CONSTANT)
    Q_PROPERTY(int listIndex READ getListIndex CONSTANT)
    Q_PROPERTY(QQmlListProperty<BookingInfo> bookingInfoList READ getBookingInfoList NOTIFY onBookingInfoListChanged)

public:
    enum Status {
        Free,
        Rented,
    };

    explicit CarBlock(const int id = 0,
                      const QString & brand = "Marka",
                      const QString & model = "Model",
                      const QString & licensePlate = "-",
                      bool status = false,
                      const QString & photoPath = "images/car.png",
                      const int listIndex = -1,
                      QObject *parent = 0);

    Q_INVOKABLE const int getId() {return m_id;}
    Q_INVOKABLE const QString getBrand() {return m_brand;}
    Q_INVOKABLE const QString getModel() {return m_model;}
    Q_INVOKABLE const QString getLicensePlate() {return m_licensePlate;}
    Q_INVOKABLE const bool getStatus() {return m_status;}
    Q_INVOKABLE const QString getPhotoPath() {return m_photoPath;}
    Q_INVOKABLE const int getListIndex() {return m_listIndex;}

    Q_INVOKABLE QQmlListProperty<BookingInfo> getBookingInfoList() {return QQmlListProperty<BookingInfo>(this, m_bookingInfoList);}

    Q_INVOKABLE bool isDateReserved(QDate date);
    Q_INVOKABLE void readBookingEntries(QDate date);

signals:
    void onBookingInfoListChanged(QQmlListProperty<BookingInfo>);

public slots:


private:
    const int m_id;
    const QString m_brand;
    const QString m_model;
    const QString m_licensePlate;
    const bool m_status;
    const QString m_photoPath;
    const int m_listIndex;

    QSqlQueryModel m_bookingModel;

    QList<BookingInfo*> m_bookingInfoList;
};

#endif // CARBLOCK_H