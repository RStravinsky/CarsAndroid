#include "imageprovider.h"

ImageProvider::ImageProvider() : QQuickImageProvider(QQuickImageProvider::Image) //, QQmlImageProviderBase::ForceAsynchronousImageLoading)
{

}

QImage ImageProvider::requestImage(const QString & id, QSize * size, const QSize & requestedSize)
{
    qDebug() << "work" << endl;
    QImage image;
    m_imageModel.setQuery(QString("SELECT ImageBlob FROM car WHERE idCar = %1").arg(id));
    image = QImage::fromData(m_imageModel.data(m_imageModel.index(0,0)).toByteArray());
    *size = image.size();
    return image;
}
