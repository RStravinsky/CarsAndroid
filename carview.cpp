#include "carview.h"

CarView::CarView(QObject *parent) : QObject(parent) { qDebug() << "Constructor "; setIsBusy(true);}

void CarView::setCarList()
{
    setIsBusy(true);
    QCoreApplication::processEvents();
    QThread::msleep(50);

    m_carModel.setQuery("SELECT * FROM car;");
    m_carList.clear();

    for(int i = 0; i < m_carModel.rowCount(); ++i) {
        m_carList.push_back(std::move(new CarBlock(m_carModel.index(i, 0).data().toInt(),
                                                   m_carModel.index(i, 1).data().toString(),
                                                   m_carModel.index(i, 2).data().toString(),
                                                   m_carModel.index(i, 3).data().toString(),
                                                   static_cast<bool>(m_carModel.index(i, 7).data().toInt()),
                                                   m_carModel.index(i, 8).data().toString(),
                                                   m_carModel.index(i, 6).data().toInt(),
                                                   i
                                                   )));
    }

    qSort(m_carList.begin(), m_carList.end(), [](CarBlock * const v1,  CarBlock * const v2)
    {
        if (v1->getBrand() == v2->getBrand())
            return v1->getModel() < v2->getModel();
        return v1->getBrand() < v2->getBrand();
    });

    int i = 0;
    std::for_each(m_carList.begin(), m_carList.end(), [&i](CarBlock * car) { car->setListIndex(i++); });

    setIsBusy(false);
    QCoreApplication::processEvents();
    QThread::msleep(50);

    emit onCarListChanged(getCarList());
}

int CarView::carListCount(QQmlListProperty<CarBlock>*list)
{
    CarView *carView = qobject_cast<CarView*>(list->object);
    if (carView)
        return carView->m_carList.count();
    return 0;
}

CarBlock* CarView::carListAt(QQmlListProperty<CarBlock> *list, int i)
{
    CarView *carView = qobject_cast<CarView*>(list->object);
    if (carView)
        return carView->m_carList.at(i);
    return 0;
}

void CarView::clearCarList()
{
    m_carList.clear();
    emit onCarListChanged(getCarList());
}

int CarView::findCarListIndex(QString searchField)
{
    auto it = std::find_if(m_carList.begin(), m_carList.end(), [searchField] (CarBlock * car) {
            if (car == nullptr) return false;
            return car->getModel().contains(searchField,Qt::CaseInsensitive) || car->getBrand().contains(searchField,Qt::CaseInsensitive) || QString::number(car->getMileage()).contains(searchField,Qt::CaseInsensitive);
          });

    if (it != m_carList.end()) {
      return (*it)->getListIndex();
    }

    return -1;
}

void CarView::setIsBusy(bool isBusy)
{
    m_isBusy = isBusy;
    qDebug() << "Is busy = " << m_isBusy << endl;
    emit onIsBusyChanged(getIsBusy());
}

QString CarView::generateCode()
{
    const int codeSize = 6;
    std::srand(time(NULL));

    std::string code("",codeSize);
    static const char alphanum[] = "0123456789";

    for (int i = 0; i < codeSize; ++i)
        code[i] = alphanum[rand() % (sizeof(alphanum) - 1)];

    return QString::fromStdString(code);
}

