#include "sqldatabase.h"

SqlDatabase :: SqlDatabase ( QObject * parent ) : QObject ( parent ) {
    m_connected = false;
}

QSqlDatabase SqlDatabase::m_sqlDatabase = QSqlDatabase();
bool SqlDatabase::m_isLocal = false;

bool SqlDatabase::connectToDatabase ( QString host, int port, QString username, QString password) {

    purgeDatabase();
    m_connected = false;
    m_sqlDatabase = QSqlDatabase::addDatabase ( "QMYSQL" );
    m_sqlDatabase.setHostName ( host );
    m_sqlDatabase.setPort( port );
    m_sqlDatabase.setUserName ( username );
    m_sqlDatabase.setPassword ( password );
    m_sqlDatabase.setDatabaseName ("sigmacars");

    qDebug() << "host=" << host << endl;
    qDebug() << "pass=" << password << endl;
    qDebug() << "user=" << username << endl;
    qDebug() << "port=" << port << endl;

    if(host == "127.0.0.1") setConnectionType(true);
    else setConnectionType(false);

    if (isOpen()) m_connected = true;

    qDebug() << "m_connected=" << m_connected << endl;

    emit connectedChanged();
    return m_connected;
}

void SqlDatabase::setConnectionType(bool type)
{
    m_isLocal = type;
}

bool SqlDatabase::isOpen()
{
    if(m_isLocal)
        return m_sqlDatabase.open();
    else {
        if(isConnectedToNetwork())
            return m_sqlDatabase.open();
    }

    return false;
}

bool SqlDatabase::isConnectedToNetwork()
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

void SqlDatabase::purgeDatabase()
{
    QString connection;
    connection = m_sqlDatabase.connectionName();
    m_sqlDatabase.close();
    m_sqlDatabase = QSqlDatabase();
    m_sqlDatabase.removeDatabase(connection);
}
