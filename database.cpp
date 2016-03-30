#include "database.h"

QSqlDatabase Database::sqlDatabase = QSqlDatabase();

bool Database::isLocal = false;

Database::Database(QObject *parent) : QObject(parent)
{
}

bool Database::connectToDatabase()
{
    if (!sqlDatabase.open()) return false;
    else return true;
}

bool Database::isOpen()
{
    if(isLocal){
        //qDebug() << "LOCAL";
        return sqlDatabase.isOpen();
    }
    else {
        //qDebug() << "REMOTE";
        if(isConnectedToNetwork()){
            //qDebug() << "Network OK!";
            return sqlDatabase.isOpen();
        }
        else{
            //qDebug() << "Network ERROR!";
            return false;
        }
    }
}

bool Database::isConnectedToNetwork()
{
    QEventLoop eventLoop;
    QNetworkAccessManager manager;
    connect(&manager,SIGNAL(finished(QNetworkReply*)),&eventLoop,SLOT(quit()));
    QNetworkRequest request(QUrl(QString("http://google.com/")));
    QNetworkReply * reply = manager.get(request);
    eventLoop.exec();
    bool result = false;

    if(reply->error() == QNetworkReply::NoError) {
        result = true;
    }

    delete reply;
    return result;
}

void Database::setParameters(const QString & hostname, int port, const QString & database, const QString & user, const QString & password)
{
    sqlDatabase = QSqlDatabase::addDatabase("QMYSQL");
    sqlDatabase.setHostName(hostname);
    sqlDatabase.setPort(port);
    sqlDatabase.setDatabaseName(database);
    sqlDatabase.setUserName(user);
    sqlDatabase.setPassword(password);
}

void Database::purgeDatabase()
{
    QString connection;
    connection = sqlDatabase.connectionName();
    sqlDatabase.close();
    sqlDatabase = QSqlDatabase();
    //qDebug() << "+++" <<QSqlDatabase::connectionNames() << "+++";
    sqlDatabase.removeDatabase(connection);
}
