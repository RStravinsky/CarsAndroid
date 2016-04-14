#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>
#include <QDateTime>
#include <QDebug>
#include <QQmlListProperty>
#include <QClipboard>
#include <QApplication>
#include "singlecode.h"

class FileIO : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<SingleCode> codeList READ getCodeList NOTIFY onCodeListChanged)
    QList<SingleCode*> m_codeList;

public slots:
    bool writeCode(const QString& data,const QString& carName);
    bool readCodes();
    void saveToClipboard(const QString& code);
    bool removeCode(const QString& code);

signals:
    void error(const QString& msg);
    void onCodeListChanged(QQmlListProperty<SingleCode>);

public:
    FileIO(QObject *parent = 0);
    QQmlListProperty<SingleCode> getCodeList() { return QQmlListProperty<SingleCode>(this, m_codeList); }
};

#endif // FILEIO_H
