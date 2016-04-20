TEMPLATE = app

QT += qml quick widgets sql

CONFIG += c++11
CONFIG += debug

SOURCES += main.cpp \
    carview.cpp \
    carblock.cpp \
    bookinginfo.cpp \
    sqldatabase.cpp \
    fileio.cpp \
    singlecode.cpp \
    imageprovider.cpp

RESOURCES += qml.qrc \
    resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    main.qml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

HEADERS += \
    carview.h \
    carblock.h \
    bookinginfo.h \
    sqldatabase.h \
    fileio.h \
    singlecode.h \
    imageprovider.h

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
        ANDROID_EXTRA_LIBS = \
        /home/bartek/AndroidMysql/mariadb_client-2.0.0-src/build/libmariadb/libmariadb.so
        }
