#ifndef BOOKINGINFO_H
#define BOOKINGINFO_H

#include <QObject>
#include <QTime>
#include <QDebug>

class BookingInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ getId CONSTANT)
    Q_PROPERTY(QString name READ getName CONSTANT)
    Q_PROPERTY(QString surname READ getSurname CONSTANT)
    Q_PROPERTY(QString from READ getFrom CONSTANT)
    Q_PROPERTY(QString to READ getTo CONSTANT)
    Q_PROPERTY(QString destination READ getDestination CONSTANT)

public:
    explicit BookingInfo(QObject *parent = 0) {}
    explicit BookingInfo(int id, QString name, QString surname, QString from, QString to, QString destination, QObject *parent = 0)
                        : m_id(id), m_name(name), m_surname(surname), m_from(from), m_to(to), m_destination(destination) {
        qDebug() << "ID = " << m_id << endl;
    }

    Q_INVOKABLE int getId() {return m_id;}
    Q_INVOKABLE QString getName() {return m_name;}
    Q_INVOKABLE QString getSurname() {return m_surname;}
    Q_INVOKABLE QString getFrom() {return m_from;}
    Q_INVOKABLE QString getTo() {return m_to;}
    Q_INVOKABLE QString getDestination() {return m_destination;}

private:
    int m_id;
    const QString m_name;
    const QString m_surname;
    const QString m_from;
    const QString m_to;
    const QString m_destination;
};

#endif // BOOKINGINFO_H

