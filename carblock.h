#ifndef CARBLOCK_H
#define CARBLOCK_H

#include <QObject>
#include <QtSql>
#include <QQmlListProperty>
#include <QMessageBox>
#include <memory>
#include "bookinginfo.h"
#include "sqldatabase.h"

class BookingInfo;

class CarBlock : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ getId CONSTANT)
    Q_PROPERTY(QString brand READ getBrand CONSTANT)
    Q_PROPERTY(QString model READ getModel CONSTANT)
    Q_PROPERTY(QString licensePlate READ getLicensePlate CONSTANT)
    Q_PROPERTY(bool isRented READ getIsRented CONSTANT)
    Q_PROPERTY(QString photoPath READ getPhotoPath CONSTANT)
    Q_PROPERTY(int listIndex READ getListIndex CONSTANT)
    Q_PROPERTY(int mileage READ getMileage CONSTANT)
    Q_PROPERTY(QQmlListProperty<BookingInfo> bookingInfoList READ getBookingInfoList NOTIFY onBookingInfoListChanged)
    Q_PROPERTY(QVariantList historyInfoList READ getHistoryInfoList NOTIFY onHistoryInfoListChanged)

public:

    explicit CarBlock(const int id = 0,
                      const QString & brand = "Marka",
                      const QString & model = "Model",
                      const QString & licensePlate = "-",
                      bool isRented = false,
                      const QString & photoPath = "images/car.png",
                      const int mileage = 0,
                      const int listIndex = -1,
                      QObject *parent = 0);

    Q_INVOKABLE const int getId() {return m_id;}
    Q_INVOKABLE const QString getBrand() {return m_brand;}
    Q_INVOKABLE const QString getModel() {return m_model;}
    Q_INVOKABLE const QString getLicensePlate() {return m_licensePlate;}
    Q_INVOKABLE const bool getIsRented() {return m_isRented;}
    Q_INVOKABLE const QString getPhotoPath() {return m_photoPath;}
    Q_INVOKABLE const int getListIndex() {return m_listIndex;}
    Q_INVOKABLE const int getMileage() {return m_mileage;}

    Q_INVOKABLE QQmlListProperty<BookingInfo> getBookingInfoList() {return QQmlListProperty<BookingInfo>(this, nullptr, &bookingInfoListCount, &bookingInfoListAt);}
    static int bookingInfoListCount(QQmlListProperty<BookingInfo>*list);
    static BookingInfo* bookingInfoListAt(QQmlListProperty<BookingInfo> *list, int i);

    QVariantList getHistoryInfoList() { return m_historyList; }
    void setListIndex(int idx) { m_listIndex = idx; }

signals:
    void onBookingInfoListChanged(QQmlListProperty<BookingInfo>);
    void onHistoryInfoListChanged(QVariantList);

public slots:
    int isDateReserved(QDate date);
    bool addToHistory(QVariant entryFields, QString code);
    bool updateHistory(QVariant entryFields, int distance);
    bool addToBooking(QVariant entryFields);
    bool isCodeCorrect(int id, QString code);
    void readBookingEntries(QDate date, QString time);
    bool isDateCorrect(QDateTime dateTime);
    bool checkDates(QDateTime begin, QDateTime end);
    int setHoursColor(QDate date, QString time);
    int getBookingInfoListSize() { return m_bookingInfoList.size(); }
    void updateBookingModel() { m_bookingModel.setQuery(QString("SELECT * FROM booking WHERE idCar = %1").arg(m_id)); }

private:
    const int m_id;
    const QString m_brand;
    const QString m_model;
    const QString m_licensePlate;
    const bool m_isRented;
    const QString m_photoPath;
    const int m_mileage;
    int m_listIndex;
    QSqlQueryModel m_bookingModel;
    QSqlQueryModel m_historyModel;
    QList<BookingInfo*> m_bookingInfoList;
    QVariantList m_historyList;
};

#endif // CARBLOCK_H
