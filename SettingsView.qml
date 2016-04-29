import QtQuick 2.5
import QtQuick.Dialogs 1.2

Item {
    id:settingsView
    anchors.fill: parent
    property alias area: area

    SwipeArea {
        id: mouse
        menu: menuView
        anchors.fill: parent
        onMove: {
            area.enabled = false
            menuView.x = (-mainArea.width * menuView.currentIndex) + x // changing menu x
            normalViewMask.opacity = (1 -((Math.abs(menuView.x)/menuView.width)))/1.5 // changing normal view opacity
        }
        onSwipe: {
            mainArea.menuChange()
        }
        onCanceled: {
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

        Rectangle {
            id: settingsHeader; width: parent.width; height:  2.5 * font.pointSize
            anchors { top: parent.top; topMargin: 5 }
            color: "lightgray"
            Text {
                anchors.fill: parent
                text: "Ustawienia serwera:"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pointSize: 9 * point
            }
        }

        // text fields
        SettingsFields { id: settingsFields; width: parent.width; height:  area.areaHeight * .3
            anchors { top: settingsHeader.bottom; topMargin: 5 }
        }

        Rectangle {
            id: userHeader; width: parent.width; height:   2.5 * font.pointSize
            anchors { top: settingsFields.bottom; topMargin: 50 }
            color: "lightgray"
            Text {
                anchors.fill: parent
                text: "Dane użytkownika:"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pointSize: 9 * point
            }
        }

        // text fields
        UserFields { id: userFields; width: parent.width; height:  area.areaHeight * .3
            anchors { top: userHeader.bottom; topMargin: 5 }
        }

        ActionButton { id: connectBtn; width: parent.width; height: area.areaHeight * .13;
            anchors { bottom: parent.bottom; left: parent.left; right: parent.right; }
            buttonColor: "#32b678"
            buttonText: qsTr("Połącz")
            fontSize: 16 * point

            Connections {
                target: fileio
                onError: { loadingRect.isLoading = false; messageDialog.show("Uwaga!", msg, StandardIcon.Warning, false) }
            }


            onActivated: {
                //area.forceActiveFocus() // disable focus from fields
                if(settingsFields.dataIsEmpty() || userFields.dataIsEmpty()) {
                    messageDialog.show("Uwaga!", "Pole tekstowe nie zostało wypełnione.", StandardIcon.Warning, false);
                }

                else {
                    loadingRect.isLoading = true
                    if(fileio.writeSettings(settingsFields.getFields(),userFields.getFields())) {
                        sqlDatabase.purgeDatabase()
                        apps.reloadWindow() }
                }

            } // OnActivated

        } // ActiveButton

    } // Rectangle

} // Item
