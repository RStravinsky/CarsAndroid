#ifndef SINGLECODE_H
#define SINGLECODE_H

#include <QObject>

class SingleCode : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString code READ getCode CONSTANT)
    Q_PROPERTY(QString brand READ getBrand CONSTANT)
    Q_PROPERTY(QString model READ getModel CONSTANT)
    Q_PROPERTY(QString date READ getDate CONSTANT)
    Q_PROPERTY(QString time READ getTime CONSTANT)

public:
    explicit SingleCode(QObject *parent = 0);
    explicit SingleCode(QString code, QString brand, QString model, QString date, QString time, QObject *parent = 0) : m_code(code), m_brand(brand), m_model(model), m_date(date), m_time(time) {}

    Q_INVOKABLE QString getCode() {return m_code;}
    Q_INVOKABLE QString getBrand() {return m_brand;}
    Q_INVOKABLE QString getModel() {return m_model;}
    Q_INVOKABLE QString getDate() {return m_date;}
    Q_INVOKABLE QString getTime() {return m_time;}

signals:

public slots:

private:
    const QString m_code;
    const QString m_brand;
    const QString m_model;
    const QString m_date;
    const QString m_time;
};

#endif // SINGLECODE_H

