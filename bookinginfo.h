#ifndef BOOKINGINFO_H
#define BOOKINGINFO_H

#include <QObject>
#include <QTime>

class BookingInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ getName CONSTANT)
    Q_PROPERTY(QString surname READ getSurname CONSTANT)
    Q_PROPERTY(QString from READ getFrom CONSTANT)
    Q_PROPERTY(QString to READ getTo CONSTANT)

public:
    explicit BookingInfo(QObject *parent = 0) {}
    explicit BookingInfo(QString name, QString surname, QString from, QString to, QObject *parent = 0) : m_name(name), m_surname(surname), m_from(from), m_to(to) {}

    Q_INVOKABLE QString getName() {return m_name;}
    Q_INVOKABLE QString getSurname() {return m_surname;}
    Q_INVOKABLE QString getFrom() {return m_from;}
    Q_INVOKABLE QString getTo() {return m_to;}

signals:

public slots:

private:
    const QString m_name;
    const QString m_surname;
    const QString m_from;
    const QString m_to;
};

#endif // BOOKINGINFO_H

