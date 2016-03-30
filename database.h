#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QtSql>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkAccessManager>
#include <QUrl>

class Database : public QObject
{
    Q_OBJECT

private:
    static QSqlDatabase sqlDatabase;
    static bool isConnectedToNetwork();

public:
    explicit Database(QObject *parent = 0);
    static QSqlDatabase getDatabase() {return sqlDatabase;}
    static bool connectToDatabase();
    static bool isOpen();
    static void purgeDatabase();
    static void setParameters(const QString &hostname, int port, const QString &database, const QString &user, const QString &password);
    static QString returnHostname() {return sqlDatabase.hostName();}
    static bool isLocal;
};

#endif // DATABASE_H
