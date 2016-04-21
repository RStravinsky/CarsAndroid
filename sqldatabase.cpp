#include "sqldatabase.h"

SqlDatabase :: SqlDatabase ( QObject * parent ) : QObject ( parent ) {
    m_connected = false;
}

QSqlDatabase SqlDatabase::m_sqlDatabase = QSqlDatabase();

bool SqlDatabase::connectToDatabase ( QString host, int port, QString username, QString password) {

    qDebug() << "PURGETE" << endl;
    purgeDatabase();

    qDebug() << "host=" << host << endl;
    qDebug() << "pass=" << password << endl;
    qDebug() << "user=" << username << endl;
    qDebug() << "port=" << port << endl;

    m_sqlDatabase = QSqlDatabase::addDatabase ( "QMYSQL" );
    m_sqlDatabase.setHostName ( host );
    m_sqlDatabase.setPort( port);
    m_sqlDatabase.setUserName ( username );
    m_sqlDatabase.setPassword ( password );
    m_sqlDatabase.setDatabaseName ("sigmacars");

    if (isOpen()) m_connected = true;

    emit connectedChanged();

    qDebug() << "m_connected = " << m_connected << endl;

    return m_connected;
}

bool SqlDatabase::isOpen()
{
    if(isConnectedToNetwork())
        return m_sqlDatabase.open();

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

    qDebug() << "Network = " << result << endl;
    return result;
}

void SqlDatabase::purgeDatabase()
{
    QString connection;
    connection = m_sqlDatabase.connectionName();
    m_sqlDatabase.close();
    m_sqlDatabase = QSqlDatabase();
    m_sqlDatabase.removeDatabase(connection);
    m_connected = false;
}
