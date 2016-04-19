import QtQuick 2.5
import QtQuick.Dialogs 1.2

Item {
    id:settingsView
    anchors.fill: parent

    SwipeArea {
        id: mouse
        menu: menuView
        anchors.fill: parent
        onMove: {
            console.log("onMove...")
            area.enabled = false
            menuView.x = (-mainArea.width * menuView.currentIndex) + x // changing menu x
            normalViewMask.opacity = (1 -((Math.abs(menuView.x)/menuView.width)))/1.5 // changing normal view opacity
        }
        onSwipe: {
            console.log("onSwipe...")
            mainArea.menuChange()
        }
        onCanceled: {
            console.log("onCanceled...")
            menuView.currentIndexChanged()
            normalViewMask.opacity = menuView.currentIndex === 1 ? 0 : 0.7
            area.enabled = menuView.currentIndex === 1 ? true : false
        }
    }

    Rectangle {
        id: area
        property int offset: 20
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; top: parent.top; margins: offset }
        property int areaHeight: (screenH - topFrame.height - (2*offset))
        enabled: (loadingRect.isLoading === true) ? false : true

        // text fields
        SettingsFields { id: settingsFields; width: parent.width; height:  area.areaHeight * .55
            anchors { top: parent.top; topMargin: 5 }
        }

        // rent/return button
        ActionButton { id: connectBtn; width: parent.width; height: area.areaHeight * .13;
            property var fields;
            anchors { bottom: parent.bottom; left: parent.left; right: parent.right; }
            buttonColor: "#32b678"
            buttonText: qsTr("Połącz")
            fontSize: 16 * point
            z: settingsView.z + 1 // before parent

            Connections {
                target: fileio
                onError: { messageDialog.show("Uwaga!", msg, StandardIcon.Warning) }
            }

            onActivated: {
                area.forceActiveFocus() // disable focus from fields
                if(settingsFields.dataIsEmpty()) {
                    messageDialog.show("Uwaga!", "Pole tekstowe nie zostało wypełnione.", StandardIcon.Warning);
                    return;
                }
                else {
                    loadingRect.isLoading = true
                    fields = settingsFields.getFields()
                    console.log("SettingView - host = ",fields[0])
                    console.log("SettingView - port = ",fields[1])
                    console.log("SettingView - name = ",fields[2])
                    console.log("SettingView - password = ",fields[3])

                    if(fileio.writeSettings(settingsFields.getFields())) { apps.reloadWindow() }
                }

            } // OnActivated

        } // ActiveButton

    } // Rectangle

} // Item
