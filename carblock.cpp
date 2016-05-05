#include "carblock.h"

CarBlock::CarBlock(const int id,
                   const QString & brand,
                   const QString & model,
                   const QString & licensePlate,
                   bool isRented,
                   const QString & photoPath,
                   const int mileage,
                   const int listIndex,
                   QObject *parent)
                   : m_id(id),
                     m_brand(brand),
                     m_model(model),
                     m_licensePlate(licensePlate),
                     m_isRented(isRented),
                     m_photoPath(photoPath),
                     m_mileage(mileage),
                     m_listIndex(listIndex)
{

    m_bookingModel.setQuery(QString("SELECT * FROM booking WHERE idCar = %1").arg(id));

    m_historyModel.setQuery(QString("SELECT Name,Surname,Destination,Target FROM history WHERE idCar = %1 AND End IS NULL").arg(id));
    if(m_historyModel.rowCount() > 0) {
        for(int i=0;i<4;++i) {
            m_historyList.insert(i, m_historyModel.data(m_historyModel.index(0,i)).toString());
            //qDebug() <<  m_historyModel.data(m_historyModel.index(0,i)).toString() << endl;
        }

        emit onHistoryInfoListChanged(getHistoryInfoList());
    }

}

int CarBlock::bookingInfoListCount(QQmlListProperty<BookingInfo> *list)
{
    CarBlock *carBlock = qobject_cast<CarBlock*>(list->object);
    if (carBlock)
        return carBlock->m_bookingInfoList.count();
    return 0;
}

BookingInfo *CarBlock::bookingInfoListAt(QQmlListProperty<BookingInfo> *list, int i)
{
    CarBlock *carBlock = qobject_cast<CarBlock*>(list->object);
    if (carBlock)
        return carBlock->m_bookingInfoList.at(i);
    return 0;
}

int CarBlock::isDateReserved(QDate date)
{
    QDate modelDateTimeBegin = QDate::currentDate(), modelDateTimeEnd = QDate::currentDate();

    // 0 - white (free)
    // 1 - orange (contain reservation)
    // 2 - red (day reserved)

    qDebug() << "isDateReserved" << endl;

    for(int i = 0; i < m_bookingModel.rowCount(); ++i) {

        modelDateTimeBegin = m_bookingModel.data(m_bookingModel.index(i,3)).toDate();
        modelDateTimeEnd = m_bookingModel.data(m_bookingModel.index(i,4)).toDate();

        if(modelDateTimeBegin < date && modelDateTimeEnd > date)
            return 2;

        if(date >= modelDateTimeBegin && date <=modelDateTimeEnd) {
            return 1;
        }
    }

    return 0;
}

void CarBlock::readBookingEntries(QDate date, QString time)
{

    QTime modelTimeBegin = QTime::fromString(time, "hh:mm");
    QDateTime clickedDateTimeBegin(date, modelTimeBegin);
    QDateTime clickedDateTimeEnd(clickedDateTimeBegin.addSecs(3599));
    QDateTime modelDateTimeBegin = QDateTime::currentDateTime(), modelDateTimeEnd = QDateTime::currentDateTime();

    qDebug() << "readBookingEntries" << endl;
    m_bookingInfoList.clear();

    for(int i = 0; i < m_bookingModel.rowCount(); ++i) {

        modelDateTimeBegin = m_bookingModel.data(m_bookingModel.index(i,3)).toDateTime();
        modelDateTimeEnd = m_bookingModel.data(m_bookingModel.index(i,4)).toDateTime();

        if(clickedDateTimeBegin.date() >= modelDateTimeBegin.date() && clickedDateTimeBegin.date() <= modelDateTimeEnd.date()) {

            if((modelDateTimeBegin >= clickedDateTimeBegin) && (modelDateTimeBegin < clickedDateTimeEnd) && (modelDateTimeEnd >= clickedDateTimeBegin) && (modelDateTimeEnd < clickedDateTimeEnd)) {

                m_bookingInfoList.push_back(std::move(new BookingInfo(
                                                          m_bookingModel.data(m_bookingModel.index(i,0)).toInt(),
                                                          m_bookingModel.data(m_bookingModel.index(i,1)).toString(),
                                                          m_bookingModel.data(m_bookingModel.index(i,2)).toString(),
                                                          m_bookingModel.data(m_bookingModel.index(i,3)).toTime().toString("hh:mm"),
                                                          m_bookingModel.data(m_bookingModel.index(i,4)).toTime().toString("hh:mm"),
                                                          m_bookingModel.data(m_bookingModel.index(i,6)).toString()
                                                          )));

            }
            else if((modelDateTimeBegin >= clickedDateTimeBegin) && (modelDateTimeBegin < clickedDateTimeEnd) && (modelDateTimeEnd >= clickedDateTimeEnd)) {

                m_bookingInfoList.push_back(std::move(new BookingInfo(
                                                          m_bookingModel.data(m_bookingModel.index(i,0)).toInt(),
                                                          m_bookingModel.data(m_bookingModel.index(i,1)).toString(),
                                                          m_bookingModel.data(m_bookingModel.index(i,2)).toString(),
                                                          m_bookingModel.data(m_bookingModel.index(i,3)).toTime().toString("hh:mm"),
                                                          QString("..."),
                                                          m_bookingModel.data(m_bookingModel.index(i,6)).toString()
                                                          )));

            }
            else if((modelDateTimeBegin < clickedDateTimeBegin) && (modelDateTimeEnd >= clickedDateTimeBegin) && (modelDateTimeEnd < clickedDateTimeEnd)) {

                m_bookingInfoList.push_back(std::move(new BookingInfo(
                                                          m_bookingModel.data(m_bookingModel.index(i,0)).toInt(),
                                                          m_bookingModel.data(m_bookingModel.index(i,1)).toString(),
                                                          m_bookingModel.data(m_bookingModel.index(i,2)).toString(),
                                                          QString("..."),
                                                          m_bookingModel.data(m_bookingModel.index(i,4)).toTime().toString("hh:mm"),
                                                          m_bookingModel.data(m_bookingModel.index(i,6)).toString()
                                                          )));

            }
            else if((modelDateTimeBegin < clickedDateTimeBegin)  && (modelDateTimeEnd > clickedDateTimeEnd)) {

                m_bookingInfoList.push_back(std::move(new BookingInfo(
                                                          m_bookingModel.data(m_bookingModel.index(i,0)).toInt(),
                                                          m_bookingModel.data(m_bookingModel.index(i,1)).toString(),
                                                          m_bookingModel.data(m_bookingModel.index(i,2)).toString(),
                                                          QString("..."),
                                                          QString("..."),
                                                          m_bookingModel.data(m_bookingModel.index(i,6)).toString()
                                                          )));

            }
        }

    }

    qSort(m_bookingInfoList.begin(),m_bookingInfoList.end(), [](BookingInfo * const v1,  BookingInfo * const v2) { return v1->getFrom() < v2->getFrom(); });
    emit onBookingInfoListChanged(getBookingInfoList());
}

bool CarBlock::isDateCorrect(QDateTime dateTime)
{
    QDateTime modelBegin;
    QDateTime modelEnd;

    qDebug() << "isDateCorrect"  << endl;


    for(auto & elem : m_bookingInfoList) {

        if(elem->getFrom() != "...") {
            modelBegin = QDateTime::fromString(QString(dateTime.date().toString("yyyy-MM-dd") + " " + elem->getFrom()), "yyyy-MM-dd hh:mm");
        }
        else
            modelBegin = QDateTime::fromString(QString("1970-01-01 00:00:00"), QString("yyyy-MM-dd hh:mm:ss"));

        if(elem->getTo() != "...") {
            modelEnd = QDateTime::fromString(QString(dateTime.date().toString("yyyy-MM-dd") + " " + elem->getTo()), "yyyy-MM-dd hh:mm");
        }
        else
            modelEnd = QDateTime::fromString(QString("2070-01-01 00:00:00"), QString("yyyy-MM-dd hh:mm:ss"));

        qDebug() << "Date time: " << dateTime << endl;
        qDebug() << "Model begin " << modelBegin << endl;
        qDebug() << "Model end " << modelEnd << endl;

        if(dateTime >= modelBegin && dateTime <= modelEnd)
            return false;

    }

    return true;

}


bool CarBlock::checkDates(QDateTime begin, QDateTime end)
{
    QDateTime modelDateTimeBegin = QDateTime::currentDateTime(), modelDateTimeEnd = QDateTime::currentDateTime();

    for(int i = 0; i < m_bookingModel.rowCount(); ++i) {

        modelDateTimeBegin = m_bookingModel.data(m_bookingModel.index(i,3)).toDateTime();
        modelDateTimeEnd = m_bookingModel.data(m_bookingModel.index(i,4)).toDateTime();


            if((begin >= modelDateTimeBegin) && (end <= modelDateTimeEnd)) {
                qDebug() << "Następiło sklejenie 1. typu";
                return false;
            }
            else if((begin <= modelDateTimeBegin) && (end >= modelDateTimeEnd)) {
                qDebug() << "Następiło sklejenie 2. typu";
                return false;
            }
            else if((begin <= modelDateTimeBegin) && (end >= modelDateTimeEnd) && (end <= modelDateTimeEnd)) {
                qDebug() << "Następiło sklejenie 3. typu";
                return false;
            }
            else if((begin >= modelDateTimeBegin) && (begin <= modelDateTimeEnd) && (end >= modelDateTimeEnd)) {
                qDebug() << "Następiło sklejenie 4. typu";
                return false;
            }
    }

    return true;
}

bool CarBlock::addToHistory(QVariant entryFields, QString code)
{
    if(SqlDatabase::isOpen()) {

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

        qry.bindValue(":_Name", entryFieldsList.at(ENTRY_FIELDS::Name));
        qry.bindValue(":_Surname", entryFieldsList.at(ENTRY_FIELDS::Surename));
        qry.bindValue(":_Begin", QDateTime::currentDateTime());
        qry.bindValue(":_Status", 1);
        qry.bindValue(":_idCar", m_id);
        qry.bindValue(":_Destination", entryFieldsList.at(ENTRY_FIELDS::Destination));
        qry.bindValue(":_Target", entryFieldsList.at(ENTRY_FIELDS::Target));
        qry.bindValue(":_Code", code);

        if(!qry.exec()) return false;
        else return true;
    }

    return false;
}

QString CarBlock::isReservation()
{
    qDebug() << "isReservation" << endl;

    QString person = "";

    std::unique_ptr<QSqlQueryModel> bookingTable(new QSqlQueryModel(this));
    bookingTable->setQuery(QString("SELECT Name,Surname, Begin, End FROM booking WHERE idCar = %1").arg(m_id));

    for(int i=0;i<bookingTable->rowCount();++i)
    {
        if((QDateTime::currentDateTime()>= bookingTable->data(bookingTable->index(i,2)).toDateTime() &&
           QDateTime::currentDateTime()<= bookingTable->data(bookingTable->index(i,3)).toDateTime()) ||
           (QDateTime::currentDateTime().addSecs(900) >= bookingTable->data(bookingTable->index(i,2)).toDateTime() &&
           QDateTime::currentDateTime()<= bookingTable->data(bookingTable->index(i,3)).toDateTime()))
        {
            person = bookingTable->data(bookingTable->index(i,0)).toString() + " " +
                     bookingTable->data(bookingTable->index(i,1)).toString();
            return person;
        }
    }

    return person;
}

bool CarBlock::updateHistory(QVariant entryFields, int distance)
{   
    if(SqlDatabase::isOpen()) {
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
                if(!qry.exec()) return false;
                else return true;
            }
        }
    }

    return false;
}

bool CarBlock::addToBooking(QVariant entryFields, QString code)
{
    if(SqlDatabase::isOpen()) {
        QVariantList entryFieldsList = entryFields.toList();
        enum ENTRY_FIELDS{
            Begin,
            End,
            Name,
            Surname,
            Destination
        };

        QSqlQuery qry;
        qry.prepare("INSERT INTO booking (Name, Surname, Begin, End, idCar, Destination, Code) "
                    "VALUES (:_Name, :_Surname, :_Begin, :_End, :_idCar, :_Destination, :_Code);");

        qDebug() << "addToBooking" << endl;
        qry.bindValue(":_Name", entryFieldsList.at(ENTRY_FIELDS::Name));
        qry.bindValue(":_Surname", entryFieldsList.at(ENTRY_FIELDS::Surname));
        qry.bindValue(":_Begin", entryFieldsList.at(ENTRY_FIELDS::Begin));
        qry.bindValue(":_End", entryFieldsList.at(ENTRY_FIELDS::End));
        qry.bindValue(":_idCar", m_id);
        qry.bindValue(":_Destination", entryFieldsList.at(ENTRY_FIELDS::Destination));
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

bool CarBlock::isRentCodeCorrect(int id, QString code)
{
    if(SqlDatabase::isOpen()) {
        std::unique_ptr<QSqlQueryModel> historyTable(new QSqlQueryModel(this));
        historyTable->setQuery(QString("SELECT Code FROM history WHERE idCar = %1 AND End IS NULL").arg(id));
        if(code == historyTable->data(historyTable->index(0,0)).toString()) {
            qDebug() << "Return isRentCodeCorrect" << endl;
            return true;
        }
    }
    return false;
}

bool CarBlock::isReservationCodeCorrect(int id, QString code)
{
    qDebug() << "Booking ID = " << id << endl;
    if(SqlDatabase::isOpen()) {
        std::unique_ptr<QSqlQueryModel> bookingTable(new QSqlQueryModel(this));
        bookingTable->setQuery(QString("SELECT Code FROM booking WHERE idBooking = %1").arg(id));
        if(code == bookingTable->data(bookingTable->index(0,0)).toString()) {
            qDebug() << "Return isReservationCodeCorrect" << endl;
            return true;
        }
    }
    return false;
}

int CarBlock::setHoursColor(QDate date, QString time)
{
    QTime modelTimeBegin = QTime::fromString(time, "hh:mm");
    QDateTime clickedDateTimeBegin(date, modelTimeBegin);
    QDateTime clickedDateTimeEnd(clickedDateTimeBegin.addSecs(3599));

    QDateTime modelDateTimeBegin = QDateTime::currentDateTime(), modelDateTimeEnd = QDateTime::currentDateTime();
    m_bookingInfoList.clear();
    qDebug() << "setHoursColor" << endl;

    for(int i = 0; i < m_bookingModel.rowCount(); ++i) {

        modelDateTimeBegin = m_bookingModel.data(m_bookingModel.index(i,3)).toDateTime();
        modelDateTimeEnd = m_bookingModel.data(m_bookingModel.index(i,4)).toDateTime();


        if(clickedDateTimeBegin.date() >= modelDateTimeBegin.date() && clickedDateTimeBegin.date() <= modelDateTimeEnd.date()) {

            if((modelDateTimeBegin >= clickedDateTimeBegin) && (modelDateTimeBegin < clickedDateTimeEnd) && (modelDateTimeEnd >= clickedDateTimeBegin) && (modelDateTimeEnd < clickedDateTimeEnd)) {

                return 1;
            }
            else if((modelDateTimeBegin >= clickedDateTimeBegin) && (modelDateTimeBegin < clickedDateTimeEnd) && (modelDateTimeEnd >= clickedDateTimeEnd)) {

                return 1;
            }
            else if((modelDateTimeBegin < clickedDateTimeBegin) && (modelDateTimeEnd >= clickedDateTimeBegin) && (modelDateTimeEnd < clickedDateTimeEnd)) {

                return 1;
            }
            else if((modelDateTimeBegin < clickedDateTimeBegin)  && (modelDateTimeEnd > clickedDateTimeEnd)) {

                return 2;
            }
        }

    }

    return 0;
}

bool CarBlock::deleteReservation(int id)
{
    if(SqlDatabase::isOpen()) {
        QSqlQuery qry;
        qry.prepare("DELETE FROM booking WHERE idBooking = ?");
        qry.addBindValue(id);

        if(!qry.exec()) {
            return false;
        }
        else {
            return true;
        }
    }

   return false;
}

bool CarBlock::updateBookingModel()
{
     m_bookingModel.setQuery(QString("SELECT * FROM booking WHERE idCar = %1").arg(m_id));
}
