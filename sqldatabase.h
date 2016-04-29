#ifndef SQLDATABASE_H
#define SQLDATABASE_H

#include <QObject>
#include <QtSql>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkAccessManager>
#include <QUrl>

class SqlDatabase : public QObject {
    Q_OBJECT

    Q_PROPERTY ( bool connected READ connected NOTIFY connectedChanged )

public:
    SqlDatabase ( QObject * parent = 0 );
    bool connected() { return m_connected; }
    Q_INVOKABLE static bool isOpen();

public slots:
    bool connectToDatabase ( QString host, int port, QString username, QString password);
    void purgeDatabase();

private:
    static QSqlDatabase m_sqlDatabase;
    bool m_connected;
    static bool isConnectedToNetwork();

signals:
    void connectedChanged();

};

#endif // SQLDATABASE_H
