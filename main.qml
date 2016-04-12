import QtQuick 2.5

Loader {
    id: mainLoader

    active: true
    source: "MainWindow.qml"

    function reload()
    {
        var oldSource = source;
        source = "";
        source = oldSource;

        console.log("Reload MainWindow.qml")
    }

}
