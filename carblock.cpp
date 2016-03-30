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
