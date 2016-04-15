#include "fileio.h"

FileIO::FileIO(QObject *parent) : QObject(parent) {}

bool FileIO::readCodes()
{
    QFile file("/data/data/pl.sigmasa.rezerwacja/files/RENT_CODES.txt");
    m_codeList.clear();

    if ( file.open(QIODevice::ReadWrite) ) {
        QString line;
        QTextStream t( &file );
        do {
            line = t.readLine();
            if(!line.isEmpty())
                m_codeList.push_back(new SingleCode(line.split(" ").at(0), line.split(" ").at(1), line.split(" ").at(2), line.split(" ").at(3), line.split(" ").at(4)));
         } while (!line.isNull());
        file.close();

    }
    else {
        emit error("Nie można otworzyć pliku RENT_CODES.txt");
        return false;
    }

    emit onCodeListChanged(getCodeList());
    return true;
}

bool FileIO::removeCode(const QString &code)
{
    QFile file("/data/data/pl.sigmasa.rezerwacja/files/RENT_CODES.txt");
    if(file.open(QIODevice::ReadWrite | QIODevice::Text))
    {
        QString s;
        QTextStream t(&file);
        while(!t.atEnd())
        {
            QString line = t.readLine();
            if(!line.contains(code))
                s.append(line + "\n");
        }
        file.resize(0);
        t << s;
        file.close();
    }
    else {
        emit error("Nie można otworzyć pliku RENT_CODES.txt");
        return false;
    }

    for(auto it = m_codeList.begin(); it != m_codeList.end(); ++it)
    {
        SingleCode * temp = *it;
        if(temp->getCode() == code)
            m_codeList.erase(it);
    }

    emit onCodeListChanged(getCodeList());
    return true;
}

void FileIO::saveToClipboard(const QString& code)
{
    QClipboard *clipboard = QApplication::clipboard();
    clipboard->setText(code);
}

bool FileIO::writeCode(const QString& data,const QString& carName)
{
    QFile file("/data/data/pl.sigmasa.rezerwacja/files/RENT_CODES.txt");
    if (!file.open(QFile::WriteOnly | QFile::Append))
    {
        emit error("Nie można otworzyć pliku RENT_CODES.txt");
        return false;
    }

    QTextStream out(&file);
    out << data << " " << carName << " " << QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm") << "\n";
    file.close();
    return true;
}

bool FileIO::writeSettings(QVariant entryFields)
{
    QVariantList entryFieldsList = entryFields.toList();
    enum ENTRY_FIELDS{
        Host,
        Port,
        Name,
        Password,
    };

    QFile file("/data/data/pl.sigmasa.rezerwacja/files/SETTINGS.txt");
    if (!file.open(QFile::WriteOnly | QFile::Truncate))
    {
        emit error("Nie można otworzyć pliku SETTINGS.txt");
        return false;
    }

    QTextStream out(&file);
    out << entryFieldsList.at(ENTRY_FIELDS::Host).toString() << " " << entryFieldsList.at(ENTRY_FIELDS::Port).toString()  << " " << entryFieldsList.at(ENTRY_FIELDS::Name).toString() << " " << entryFieldsList.at(ENTRY_FIELDS::Password).toString()  <<  "\n";
    file.close();
    return true;
}

bool FileIO::readSettings()
{
    QFile file("/data/data/pl.sigmasa.rezerwacja/files/SETTINGS.txt");
    m_settingsList.clear();

    if ( file.open(QIODevice::ReadWrite) ) {
        QString line;
        QTextStream t( &file );
        line = t.readLine();
        if(!line.isEmpty())
                for(int i=0; i<4; ++i)
                    m_settingsList.push_back(line.split(" ").at(i));
        file.close();
    }

    else {
        emit error("Nie można otworzyć pliku SETTINGS.txt");
        return false;
    }

    //qDebug() << m_settingsList << endl;

    emit onSettingsListChanged(getSettingsList());
    return true;
}
