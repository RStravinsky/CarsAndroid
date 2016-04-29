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
    Q_PROPERTY(QVariantList settingsList READ getSettingsList NOTIFY onSettingsListChanged)
    QList<SingleCode*> m_codeList;
    QVariantList m_settingsList;

signals:
    void error(const QString& msg);
    void onCodeListChanged(QQmlListProperty<SingleCode>);
    void onSettingsListChanged(QVariantList);

public slots:
    bool writeCode(bool isRent, const QString& data,const QString& carName, const QString& dateString = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm"));
    bool readCodes();
    void saveToClipboard(const QString& code);
    bool removeCode(const QString& code);

    bool writeSettings(QVariant entryFields, QVariant userFields);
    bool readSettings();

public:
    FileIO(QObject *parent = 0);
    QQmlListProperty<SingleCode> getCodeList() { return QQmlListProperty<SingleCode>(this, m_codeList); }
    QVariantList getSettingsList() { return m_settingsList; }
};

#endif // FILEIO_H
