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
    QSqlDatabase getDatabase() {return m_sqlDatabase;}
    Q_INVOKABLE bool connectToDatabase ( QString host, QString database, QString username, QString password);

private:
    QSqlDatabase m_sqlDatabase;
    bool m_connected;
    bool m_isLocal;

    bool isConnectedToNetwork();
    Q_INVOKABLE bool isOpen();
    void setConnectionType(bool type);
    void purgeDatabase();

signals:
    void connectedChanged();

};

#endif // SQLDATABASE_H
