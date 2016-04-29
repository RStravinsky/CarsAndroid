import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import Qt.labs.controls 1.0
import QtGraphicalEffects 1.0
import QtQuick.Window 2.2

Loader {
    id: mainLoader
    active: true
    source: "MainWindow.qml"

    function reload()
    {
        source = "";
        //cacheManager.clear();
        source = "MainWindow.qml";
        //console.log("Reload MainWindow.qml")
    }
}
