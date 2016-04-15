#ifndef IMAGEPROVIDER_H
#define IMAGEPROVIDER_H

#include <QQuickImageProvider>
#include <QtSql>
#include <QImage>
#include <QDebug>

class ImageProvider : public QQuickImageProvider
{

public:
    ImageProvider();
    QImage requestImage(const QString & id, QSize * size, const QSize & requestedSize);

private:
    QSqlQueryModel m_imageModel;
    QMap<QString, QImage> m_imagesMap;
    void loadMap();
    static bool initProvider;
};

#endif // IMAGEPROVIDER_H
