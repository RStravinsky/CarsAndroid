#ifndef IMAGEPROVIDER_H
#define IMAGEPROVIDER_H

#include <QQuickImageProvider>
#include <QtSql>

class ImageProvider : public QQuickImageProvider
{

public:
    ImageProvider();

    QImage requestImage(const QString & id, QSize * size, const QSize & requestedSize);

private:
    QSqlQueryModel m_imageModel;

};

#endif // IMAGEPROVIDER_H
