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
    property double point: ppi/160

    function reloadWindow() { mainLoader.reload() }

    IntValidator { id: intValidaotr }
    RegExpValidator { id: hostRegExpValidator; regExp: /^[0-9]+\.?[0-9]+\.?[0-9]+\.?[0-9]*$/ }
    RegExpValidator { id: regExpValidator; regExp: /[a-zA-ZżźćńółęąśŻŹĆĄŚĘŁÓŃ]+/ }

    MainForm {
        id: mainForm
        anchors.fill: parent
        focus: true // important - otherwise we'll get no key events
        Keys.onReleased: {
            if (event.key === Qt.Key_Back) {
                if(menuView.currentIndex === 1) { // menu not visible

                    if(stackView.currentItem.objectName === "Wypożyczanie") { console.log("CLEAR RENT"); rentView.clearText() }
                    if(stackView.currentItem.objectName === "Rezerwacja") { console.log("CLEAR BOOK"); bookingView.clearText() }
                    if(stackView.currentItem.objectName === "Wprowadź kod") { console.log("CLEAR PIN");pinView.clearText() }
                    if(stackView.currentItem.objectName === "Ustawienia") { menuView.list.currentIndex = 0 }
                    if(stackView.currentItem.objectName === "Kody") { menuView.list.currentIndex = 0 }
                    if(stackView.currentItem.objectName === "Ustawienia") { informationScreen.z = normalView.z + 1; }

                    if(stackView.depth === 1) apps.close()
                    else  {
                        if(dateChooser.stack.depth === 1) {
                            console.log("POP");
                            stackView.pop()
                        }
                        else dateChooser.stack.pop()
                    }

                    mainArea.setState()

                }
                else { console.log("MENU CHANGE ");mainArea.menuChange() }

                console.log("ACCEPTED");
                event.accepted = true
            }
        }

        MessageDialog {
            id: messageDialog
            property bool reloadActive: false
            onAccepted: {
                if(reloadActive === true) {
                    carViewClass.isBusy = true
                    console.log("RELOADING!")
                    apps.reloadWindow()
                }
                messageDialog.close();
            }
            function show(title,caption,icon,reload) {
                messageDialog.title = title;
                messageDialog.text = caption;
                messageDialog.icon = icon;
                messageDialog.reloadActive = reload
                messageDialog.open();
            }
        }

        // top frame of application
        TopFrame { id: topFrame; width: mainForm.width; height: screenH*.1; anchors.top: mainForm.top; z: 100 }

        // settings button of application
        MainButton {
            id: mainButton; height: topFrame.height; width: mainButton.height
            anchors { left: topFrame.left; top: topFrame.top }
            z: topFrame.z
            onButtonClicked: { mainArea.menuChange() }
        }

        // update button
        UpdateButton {
            id: updateButton; height: topFrame.height; width: updateButton.height
            anchors { right: topFrame.right; top: topFrame.top }
            z: topFrame.z
            visible: stackView.currentItem.objectName === "Samochody" ? true : false
            onActivated: { apps.reloadWindow() }
        }

        // header
        Rectangle {
            width: topFrame.width - mainButton.width - updateButton.width
            height: topFrame.height
            anchors { left:mainButton.right; right: updateButton.left; top: topFrame.top; bottom: topFrame.bottom }
            z: topFrame.z
            color: "transparent"
            Text {
                id: frameText
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 12 * point
                text: "Samochody"
                color: "white"
            }
        }

        // waiting for operation
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
                font.pointSize: 14 * point
                text: "Proszę czekać ..."
                color: "white"
            }
        }

        SqlDatabase {  property var settingsParameter; id: sqlDatabase }


        Rectangle {
            id: mainArea
            anchors { top: topFrame.bottom; left: mainForm.left; right: mainForm.right; bottom: mainForm.bottom }
            width: mainForm.width

            function menuChange() {
                if(menuView.currentIndex === 0) {
                    menuView.currentIndex++
                    normalViewMask.opacity = 0
                }
                else {
                    menuView.currentIndex--
                    normalViewMask.opacity = 0.7
                }

                setState()
                mainButton.animation.start()
            }

            function setState() {
                switch(stackView.currentItem.objectName)
                {
                   case "Samochody":
                       carView.area.enabled = menuView.currentIndex === 1 ? true : false
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
                       informationScreen.z = normalView.z + 1;
                       if(stackView.currentItem.objectName === "Wypożyczanie") { rentView.clearText() }
                       if(stackView.currentItem.objectName === "Rezerwacja") { bookingView.clearText() }
                       if(stackView.currentItem.objectName === "Wprowadź kod") { pinView.clearText() }
                       mainArea.menuChange()
                       if(idx === 0) { stackView.pop(null, StackView.Immediate) }
                       else if(idx === 1) { informationScreen.z = normalView.z - 1; stackView.clear(); stackView.push(carView, StackView.Immediate, settingsView, StackView.Immediate) }
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

            // reload screen
            InformationScreen {
                id: informationScreen
                anchors.fill: parent
                z: normalView.z + 1
                onActivated: {
                    if(informationScreen.text === "Serwer niedostępny" || informationScreen.text === "Skonfiguruj połączenie") {
                         informationScreen.z = normalView.z - 1; stackView.clear(); stackView.push(carView, StackView.Immediate, settingsView, StackView.Immediate)
                    }
                }

//                MouseArea {
//                    anchors.fill: parent
//                    onClicked: mouse.accepted = true;
//                    onPressed: mouse.accepted = true;
//                    onReleased: mouse.accepted = true;
//                    onDoubleClicked: mouse.accepted = true;
//                    onPositionChanged: mouse.accepted = true;
//                    onPressAndHold: mouse.accepted = true;
//                }

            }

           Rectangle { id: normalView; anchors.fill: parent; visible: false
                CarView { id:carView; objectName: "Samochody"; Component.onCompleted: {
                        sqlDatabase.purgeDatabase()
                        carViewClass.clearCarList()
                        if(fileio.readSettings()) {
                            sqlDatabase.settingsParameter = fileio.settingsList
                            if(sqlDatabase.connectToDatabase(sqlDatabase.settingsParameter[0], sqlDatabase.settingsParameter[1], sqlDatabase.settingsParameter[2], sqlDatabase.settingsParameter[3])) {
                                carViewClass.setCarList()
                                informationScreen.visible = false;
                                console.log("visible false")
                            }
                            else {
                                messageDialog.show("Błąd!", "Nie można połaczyć z serwerem.", StandardIcon.Critical, false);
                                informationScreen.text = "Serwer niedostępny"
                                informationScreen.source = "images/images/warning.png"
                            }
                        }
                        else { // file SETTINGS.txt not open
                            informationScreen.text = "Skonfiguruj połączenie"
                            informationScreen.source = "images/images/configure.png"
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

   Component.onCompleted: { console.log("ppi: " + ppi); console.log("dpi: " + dpi); console.log("ratio: " + ratio); console.log("imageRatio: " + imageRatio) }
} // ApplicationWindow

