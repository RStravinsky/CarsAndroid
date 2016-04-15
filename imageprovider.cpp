#include "imageprovider.h"

bool ImageProvider::initProvider = true;

ImageProvider::ImageProvider() : QQuickImageProvider(QQuickImageProvider::Image)
{

}

QImage ImageProvider::requestImage(const QString & id, QSize * size, const QSize & requestedSize)
{

    Q_UNUSED(size);
    Q_UNUSED(requestedSize);

    if(initProvider) {
        loadMap();
        initProvider = false;
    }

   return m_imagesMap[id];
}

void ImageProvider::loadMap()
{
    m_imageModel.setQuery(QString("SELECT idCar, ImageBlob FROM car"));
    for(auto i = 0; i < m_imageModel.rowCount(); ++i)
        m_imagesMap.insert(m_imageModel.data(m_imageModel.index(i,0)).toString(), QImage::fromData(m_imageModel.data(m_imageModel.index(i,1)).toByteArray()));
}
