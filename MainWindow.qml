import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import Qt.labs.controls 1.0
import QtGraphicalEffects 1.0
import QtQuick.Window 2.2
import sigma.sql 1.0

ApplicationWindow {
    id: apps
    visible: true
    visibility:  "Maximized"
    title: qsTr("Rezerwacja")
    Keys.enabled: true
    Keys.priority: Keys.BeforeItem

    property int screenH: Screen.height
    property int screenW: Screen.width

    function reloadWindow() { mainLoader.reload() }

    MainForm {
        id: mainForm
        anchors.fill: parent
        focus: true // important - otherwise we'll get no key events
        Keys.onReleased: {
            if (event.key === Qt.Key_Back) {
                if(menuView.currentIndex === 1) { // menu not visible
                    if(stackView.currentItem.objectName === "Ustawienia") { console.log("Settings"); menuView.list.currentIndex = 0 }
                    if(stackView.currentItem.objectName === "Kody") { console.log("Codes"); menuView.list.currentIndex = 0 }
                    if(stackView.currentItem.objectName === "Wypożyczanie") { rentView.clearText() }
                    if(stackView.currentItem.objectName === "Rezerwacja") { bookingView.clearText() }
                    if(stackView.currentItem.objectName === "Wprowadź kod") { pinView.clearText() }

                    if(stackView.depth === 1) apps.close()
                    else  {
                        if(dateChooser.stack.depth === 1) stackView.pop()
                        else dateChooser.stack.pop()
                    }
                }
                else { mainArea.menuChange() }
                event.accepted = true
            }
        }

        MessageDialog { id: messageDialog
            onAccepted: { messageDialog.close(); }
            function show(title,caption,icon) {
                messageDialog.title = title;
                messageDialog.text = caption;
                messageDialog.icon = icon;
                messageDialog.open();
            }
        }

        // top frame of application
        TopFrame { id: topFrame; width: mainForm.width; height: screenH*.1; anchors.top: mainForm.top; z: 100 }

        // settings button of application
        MainButton {
            id: mainButton; height: topFrame.height; width: mainButton.height
            anchors { left: topFrame.left; top: topFrame.top }
            z: topFrame.z + 1 // before top frame
            onButtonClicked: { mainArea.menuChange(); }
        }

        // update button
        UpdateButton {
            id: updateButton; height: topFrame.height; width: updateButton.height
            anchors { right: topFrame.right; top: topFrame.top }
            z: topFrame.z + 1 // before top frame
            visible: stackView.currentItem.objectName === "Samochody" ? true : false
            onActivated: { apps.reloadWindow(); loadingScreen.visible = false; }
        }

        // header
        Rectangle {
            width: topFrame.width - mainButton.width - updateButton.width
            height: topFrame.height
            anchors { left:mainButton.right; right: updateButton.left; top: topFrame.top; bottom: topFrame.bottom }
            z: topFrame.z + 1 // before top frame
            color: "transparent"
            Text {
                id: frameText
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: screenH/40
                text: "Samochody"
                color: "white"
            }
        }

        // reload screen
        LoadingScreen {
            id: loadingScreen
            anchors { top: topFrame.bottom; left: mainForm.left; right: mainForm.right; bottom: mainForm.bottom }
            width: mainForm.width
            z: mainArea.z + 1
        }

        // waiting for operation screen
        Rectangle {
            property bool isLoading: false
            id: loadingRect
            anchors.fill: parent
            z: topFrame.z + 1
            color: "black"
            opacity: 0.7
            visible: loadingRect.isLoading
            Text {
                anchors.centerIn: parent
                font.pixelSize: screenH/25;
                text: "Proszę czekać ..."
                color: "white"
            }
        }

        SqlDatabase { id: sqlDatabase }

        Rectangle {
            id: mainArea
            anchors { top: topFrame.bottom; left: mainForm.left; right: mainForm.right; bottom: mainForm.bottom }
            width: mainForm.width

            function menuChange() {
                if(menuView.currentIndex === 0) {
                    menuView.currentIndex++
                    normalViewMask.opacity = 0
                    setState()
                }
                else {
                    menuView.currentIndex--
                    normalViewMask.opacity = 0.7
                    setState()
                }
                mainButton.animation.start()
            }

            function setState() {
                switch(stackView.currentItem.objectName)
                {
                   case "Samochody":
                       carView.area.enabled = menuView.currentIndex === 1 ? true : false
                       break
                   case "Ustawienia":
                       break
                   case "Data/czas":
                       dateChooser.area.enabled = menuView.currentIndex === 1 ? true : false
                       break
                   case "Wypożyczanie":
                       rentView.area.enabled = menuView.currentIndex === 1 ? true : false
                       break
                   case "Rezerwacja":
                       bookingView.area.enabled = menuView.currentIndex === 1 ? true : false
                       break
                   case "Kody":
                       codesView.area.enabled = menuView.currentIndex === 1 ? true : false
                       break
                }
           }

            MenuView {
                id:menuView
                z: normalViewMask.z + 1 // before normalView
                mainArea: mainArea
                onItemClicked: {
                       if(stackView.currentItem.objectName === "Wypożyczanie") { rentView.clearText() }
                       if(stackView.currentItem.objectName === "Rezerwacja") { bookingView.clearText() }
                       if(stackView.currentItem.objectName === "Wprowadź kod") { pinView.clearText() }
                       mainArea.menuChange()
                       if(idx === 0) { stackView.pop(null, StackView.Immediate) }
                       else if(idx === 1) { stackView.clear(); stackView.push(carView, StackView.Immediate, settingsView, StackView.Immediate) }
                       else if(idx === 2) {
                           fileio.readCodes();
                           if(stackView.currentItem.objectName === "Wprowadź kod") {
                               stackView.push(codesView)
                           }
                           else {
                               stackView.clear();
                               stackView.push(carView, StackView.Immediate, codesView, StackView.Immediate)
                           }
                       }
                       else { // HELP TODO}
                       }
                }
           } // Menu View

           Rectangle { id: normalView; anchors.fill: parent; visible: false
                CarView { id:carView; objectName: "Samochody"; Component.onCompleted: {
                        if(sqlDatabase.connectToDatabase("94.230.27.222", 3306, "root", "Serwis4q@")) {
                            carViewClass.setCarList()
                            loadingScreen.visible = false;
                        }
                        else {
                            messageDialog.show("Błąd!", "Nie można połaczyć z serwerem.", StandardIcon.Critical);
                            loadingScreen.text = "Serwer niedostępny"
                            loadingScreen.source = "images/images/warning.png"
                        }
                    }
                }
                SettingsView { id:settingsView; objectName: "Ustawienia"; }
                CodesView { id:codesView; objectName: "Kody"; }
                DateChooser {id:dateChooser; objectName: "Data/czas";}
                RentView { id:rentView; objectName: "Wypożyczanie"; }
                PinView { id:pinView; objectName: "Wprowadź kod" }
                BookingView { id:bookingView; objectName: "Rezerwacja" }
           } // Normal View

           // view mask
           Rectangle { id: normalViewMask; anchors.fill: normalView
               z: normalView.z + 1
               color: "black"
               opacity: 0
           }

           StackView {
              id: stackView
              initialItem: carView
              anchors.fill: parent
              onCurrentItemChanged: { frameText.text = stackView.currentItem.objectName }
          }

        } // MainArea

   } // MainForm

} // ApplicationWindow

