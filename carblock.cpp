#include "carblock.h"

CarBlock::CarBlock(const int id,
                   const QString & brand,
                   const QString & model,
                   const QString & licensePlate,
                   bool status,
                   const QString & photoPath,
                   const int mileage,
                   const int listIndex,
                   QObject *parent)
                   : m_id(id),
                     m_brand(brand),
                     m_model(model),
                     m_licensePlate(licensePlate),
                     m_status(status),
                     m_photoPath(photoPath),
                     m_mileage(mileage),
                     m_listIndex(listIndex)
{
   m_bookingModel.setQuery(QString("SELECT * FROM booking WHERE idCar = %1").arg(id));
}


bool CarBlock::isDateReserved(QDate date)
{
    QDate modelBegin = QDate::currentDate(), modelEnd = QDate::currentDate();

    for(int i = 0; i < m_bookingModel.rowCount(); ++i) {

        modelBegin = m_bookingModel.data(m_bookingModel.index(i,3)).toDate();
        modelEnd = m_bookingModel.data(m_bookingModel.index(i,4)).toDate();

        if(date >= modelBegin && date <=modelEnd) {
            return true;
        }

    }

    return false;
}

void CarBlock::readBookingEntries(QDate date)
{
    QDate modelBegin = QDate::currentDate(), modelEnd = QDate::currentDate();
    m_bookingInfoList.clear();

    for(int i = 0; i < m_bookingModel.rowCount(); ++i) {

        modelBegin = m_bookingModel.data(m_bookingModel.index(i,3)).toDate();
        modelEnd = m_bookingModel.data(m_bookingModel.index(i,4)).toDate();

        if(date >= modelBegin && date <= modelEnd) {

            if(modelBegin != modelEnd) {

                if(date > modelBegin && date < modelEnd)
                    m_bookingInfoList.push_back(std::move(new BookingInfo(
                                                              m_bookingModel.data(m_bookingModel.index(i,1)).toString(),
                                                              m_bookingModel.data(m_bookingModel.index(i,2)).toString(),
                                                              QString("..."),
                                                              QString("...")
                                                              )));
                else if(date == modelBegin)
                    m_bookingInfoList.push_back(std::move(new BookingInfo(
                                                              m_bookingModel.data(m_bookingModel.index(i,1)).toString(),
                                                              m_bookingModel.data(m_bookingModel.index(i,2)).toString(),
                                                              m_bookingModel.data(m_bookingModel.index(i,3)).toTime().toString("hh:mm"),
                                                              QString("...")
                                                              )));
                else if(date == modelEnd)
                    m_bookingInfoList.push_back(std::move(new BookingInfo(
                                                              m_bookingModel.data(m_bookingModel.index(i,1)).toString(),
                                                              m_bookingModel.data(m_bookingModel.index(i,2)).toString(),
                                                              QString("..."),
                                                              m_bookingModel.data(m_bookingModel.index(i,4)).toTime().toString("hh:mm")
                                                              )));


            }
            else
                m_bookingInfoList.push_back(std::move(new BookingInfo(
                                                          m_bookingModel.data(m_bookingModel.index(i,1)).toString(),
                                                          m_bookingModel.data(m_bookingModel.index(i,2)).toString(),
                                                          m_bookingModel.data(m_bookingModel.index(i,3)).toTime().toString("hh:mm"),
                                                          m_bookingModel.data(m_bookingModel.index(i,4)).toTime().toString("hh:mm")
                                                          )));

        }

    }

    emit onBookingInfoListChanged(getBookingInfoList());
}

bool CarBlock::addToHistory(QVariant entryFields, QString code)
{
    if(Database::isOpen()) {
        qDebug() << "Database::isOpen()" << endl;
        QVariantList entryFieldsList = entryFields.toList();
        enum ENTRY_FIELDS{
            Name,
            Surename,
            Destination,
            Target
        };

        QSqlQuery qry;
        qry.prepare("INSERT INTO history (Name, Surname, Begin, idCar, Destination, Target, Code) "
                    "VALUES (:_Name, :_Surname, :_Begin, :_idCar, :_Destination, :_Target, :_Code);"
                    "UPDATE car SET Status=:_Status WHERE idCar=:_idCar");

        qDebug() << "addToHistory4" << endl;
        qry.bindValue(":_Name", entryFieldsList.at(ENTRY_FIELDS::Name));
        qry.bindValue(":_Surname", entryFieldsList.at(ENTRY_FIELDS::Surename));
        qry.bindValue(":_Begin", QDateTime::currentDateTime());
        qry.bindValue(":_Status", 1);
        qry.bindValue(":_idCar", m_id);
        qry.bindValue(":_Destination", entryFieldsList.at(ENTRY_FIELDS::Destination));
        qry.bindValue(":_Target", entryFieldsList.at(ENTRY_FIELDS::Target));
        qry.bindValue(":_Code", code);
        qDebug() << "before qry.exec()" << endl;
        if(!qry.exec()) {
            qDebug() << "return false" << endl;
            return false;
        }
        else {
            qDebug() << "return true" << endl;
            return true;
        }
    }

    return false;
}

bool CarBlock::updateHistory(QVariant entryFields, int distance)
{
    QVariantList entryFieldsList = entryFields.toList();
    enum ENTRY_FIELDS{
        Mileage,
        Notes,
    };

    QSqlQuery qry;
    QString name, surname;
    QSqlQueryModel * historyTable = new QSqlQueryModel(this);
    historyTable->setQuery("SELECT * FROM history;");
    for(int i=0; i<historyTable->rowCount(); ++i){
        if(historyTable->data(historyTable->index(i,5)).toInt() == m_id &&
           historyTable->data(historyTable->index(i,4)).toDate().toString("yyyy-MM-dd") == ""){

            name = historyTable->data(historyTable->index(i,1)).toString();
            surname = historyTable->data(historyTable->index(i,2)).toString();

            if(entryFieldsList.at(ENTRY_FIELDS::Notes).toString().isEmpty()) {
                qry.prepare("UPDATE history SET End=:_End, Distance=:_Distance WHERE idCar=:_idCar AND End IS NULL;"
                            "UPDATE car SET Mileage=:_Mileage WHERE idCar=:_idCar;"
                            "UPDATE car SET Status=:_Status WHERE idCar=:_idCar");
                qry.bindValue(":_idCar", m_id);
                qry.bindValue(":_End", QDateTime::currentDateTime());
                qry.bindValue(":_Distance",distance);
                qry.bindValue(":_Mileage", entryFieldsList.at(ENTRY_FIELDS::Mileage));
                qry.bindValue(":_Status", 0);
            }

            else {
            qry.prepare("INSERT INTO notes (Contents, Name, Surname, Datetime, isRead, idCar) "
                        "VALUES (:_Contents, :_Name, :_Surname, :_Datetime, :_isRead, :_idCar);"
                        "UPDATE history SET End=:_End, Distance=:_Distance WHERE idCar=:_idCar AND End IS NULL;"
                        "UPDATE car SET Status=:_Status WHERE idCar=:_idCar;"
                        "UPDATE car SET Mileage=:_Mileage WHERE idCar=:_idCar;");
            qry.bindValue(":_Contents", entryFieldsList.at(ENTRY_FIELDS::Notes));
            qry.bindValue(":_Name", name);
            qry.bindValue(":_Surname", surname);
            qry.bindValue(":_Datetime", QDateTime::currentDateTime());
            qry.bindValue(":_isRead", 0);
            qry.bindValue(":_idCar", m_id);
            qry.bindValue(":_End", QDateTime::currentDateTime());
            qry.bindValue(":_Distance",distance);
            qry.bindValue(":_Mileage", entryFieldsList.at(ENTRY_FIELDS::Mileage));
            qry.bindValue(":_Status", 0);
            }
            if(!qry.exec())
                return false;
            else {
                qDebug() << "Return updateHistory" << endl;
                return true;
            }
        }
    }

    return false;
}

bool CarBlock::isCodeCorrect(int id, QString code)
{
    std::unique_ptr<QSqlQueryModel> historyTable(new QSqlQueryModel(this));
    historyTable->setQuery(QString("SELECT Code FROM history WHERE idCar = %1 AND End IS NULL").arg(id));
    if(code == historyTable->data(historyTable->index(0,0)).toString()) {
        qDebug() << "Return isCodeCorrect" << endl;
        return true;
    }

    return false;
}
