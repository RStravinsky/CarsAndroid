#include "carblock.h"

CarBlock::CarBlock(const int id,
                   const QString & brand,
                   const QString & model,
                   const QString & licensePlate,
                   bool status,
                   const QString & photoPath,
                   const int listIndex,
                   QObject *parent)
                   : m_id(id),
                     m_brand(brand),
                     m_model(model),
                     m_licensePlate(licensePlate),
                     m_status(status),
                     m_photoPath(photoPath),
                     m_listIndex(listIndex)
{
    m_bookingModel.setQuery(QString("SELECT * FROM booking WHERE idCar = %1").arg(id));
}

int CarBlock::bookingInfoListCount(QQmlListProperty<BookingInfo> *list)
{
    CarBlock *carBlock = qobject_cast<CarBlock*>(list->object);
    if (carBlock)
        return carBlock->m_bookingInfoList.count();
    return 0;
}

BookingInfo *CarBlock::bookinginfoListAt(QQmlListProperty<BookingInfo> *list, int i)
{
    CarBlock *carBlock = qobject_cast<CarBlock*>(list->object);
    if (carBlock)
        return carBlock->m_bookingInfoList.at(i);
    return 0;
}


bool CarBlock::isDateReserved(QDate date)
{
    QDate modelDateTimeBegin = QDate::currentDate(), modelDateTimeEnd = QDate::currentDate();

    for(int i = 0; i < m_bookingModel.rowCount(); ++i) {

        modelDateTimeBegin = m_bookingModel.data(m_bookingModel.index(i,3)).toDate();
        modelDateTimeEnd = m_bookingModel.data(m_bookingModel.index(i,4)).toDate();

        if(date >= modelDateTimeBegin && date <=modelDateTimeEnd) {
            return true;
        }

    }

    return false;
}

void CarBlock::readBookingEntries(QDate date, QString time)
{
    QTime modelTimeBegin = QTime::fromString(time, "hh:mm");
    QDateTime clickedDateTimeBegin(date, modelTimeBegin);
    QDateTime clickedDateTimeEnd(clickedDateTimeBegin.addSecs(3600));

    QDateTime modelDateTimeBegin = QDateTime::currentDateTime(), modelDateTimeEnd = QDateTime::currentDateTime();
    m_bookingInfoList.clear();

    for(int i = 0; i < m_bookingModel.rowCount(); ++i) {

        modelDateTimeBegin = m_bookingModel.data(m_bookingModel.index(i,3)).toDateTime();
        modelDateTimeEnd = m_bookingModel.data(m_bookingModel.index(i,4)).toDateTime();

        if(clickedDateTimeBegin.date() >= modelDateTimeBegin.date() && clickedDateTimeBegin.date() <= modelDateTimeEnd.date()) {

            if((modelDateTimeBegin >= clickedDateTimeBegin) && (modelDateTimeBegin < clickedDateTimeEnd) && (modelDateTimeEnd >= clickedDateTimeBegin) && (modelDateTimeEnd < clickedDateTimeEnd)) {

                m_bookingInfoList.push_back(std::move(new BookingInfo(
                                                          m_bookingModel.data(m_bookingModel.index(i,1)).toString(),
                                                          m_bookingModel.data(m_bookingModel.index(i,2)).toString(),
                                                          m_bookingModel.data(m_bookingModel.index(i,3)).toTime().toString("hh:mm"),
                                                          m_bookingModel.data(m_bookingModel.index(i,4)).toTime().toString("hh:mm")
                                                          )));

            }
            else if((modelDateTimeBegin >= clickedDateTimeBegin) && (modelDateTimeBegin < clickedDateTimeEnd) && (modelDateTimeEnd >= clickedDateTimeEnd)) {

                m_bookingInfoList.push_back(std::move(new BookingInfo(
                                                          m_bookingModel.data(m_bookingModel.index(i,1)).toString(),
                                                          m_bookingModel.data(m_bookingModel.index(i,2)).toString(),
                                                          m_bookingModel.data(m_bookingModel.index(i,3)).toTime().toString("hh:mm"),
                                                          QString("...")
                                                          )));

            }
            else if((modelDateTimeBegin < clickedDateTimeBegin) && (modelDateTimeEnd >= clickedDateTimeBegin) && (modelDateTimeEnd < clickedDateTimeEnd)) {

                m_bookingInfoList.push_back(std::move(new BookingInfo(
                                                          m_bookingModel.data(m_bookingModel.index(i,1)).toString(),
                                                          m_bookingModel.data(m_bookingModel.index(i,2)).toString(),
                                                          QString("..."),
                                                          m_bookingModel.data(m_bookingModel.index(i,4)).toTime().toString("hh:mm")
                                                          )));

            }
            else if((modelDateTimeBegin < clickedDateTimeBegin)  && (modelDateTimeEnd > clickedDateTimeEnd)) {

                m_bookingInfoList.push_back(std::move(new BookingInfo(
                                                          m_bookingModel.data(m_bookingModel.index(i,1)).toString(),
                                                          m_bookingModel.data(m_bookingModel.index(i,2)).toString(),
                                                          QString("..."),
                                                          QString("...")
                                                          )));

            }
        }

    }

    emit onBookingInfoListChanged(getBookingInfoList());
}

int CarBlock::setHoursColor(QDate date, QString time)
{
    QTime modelTimeBegin = QTime::fromString(time, "hh:mm");
    QDateTime clickedDateTimeBegin(date, modelTimeBegin);
    QDateTime clickedDateTimeEnd(clickedDateTimeBegin.addSecs(3600));

    QDateTime modelDateTimeBegin = QDateTime::currentDateTime(), modelDateTimeEnd = QDateTime::currentDateTime();
    m_bookingInfoList.clear();

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
