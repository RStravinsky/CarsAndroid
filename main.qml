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

    property int screenHight: Screen.height
    property int screenW: Screen.width
    property int screenH

    Component.onCompleted: { screenH = screenHight }

    Rectangle {
        id: loadingRect
        anchors.fill: parent
        z: topFrame.z + 100
        Image {
            id: waitImage
            height: parent.height/5
            width: parent.height/5
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            source: "images/images/wait.png"
        }

        Text {
            id: initText
            width: parent.width
            height: font.pointSize * 2
            anchors.top: waitImage.bottom
            font.pointSize: screenHight/40
            horizontalAlignment: Text.AlignHCenter
            text: "Łączenie ..."
            color: "gray"
        }
    }

    MainForm {
         id: mainForm
         anchors.fill: parent
         focus: true // important - otherwise we'll get no key events
         visible: false;
         Keys.onReleased: {
             if (event.key === Qt.Key_Back) {
                 if(menuView.currentIndex === 1) { // menu not visible
                     if(stackView.currentItem.objectName === "SettingsView") { menuView.list.currentIndex = 0 }
                     if(stackView.currentItem.objectName === "RentView") { rentView.clearText() }
                     if(stackView.currentItem.objectName === "BookingView") { bookingView.clearText() }
                     if(stackView.currentItem.objectName === "PinView") { pinView.clearText() }

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
             onAccepted: { messageDialog.close() }
             function show(title,caption,icon) {
                 messageDialog.title = title;
                 messageDialog.text = caption;
                 messageDialog.icon = icon;
                 messageDialog.open();
             }
         }

         // top frame of application
         TopFrame { id: topFrame; width: mainForm.width; height: screenH*.1; anchors.top: mainForm.top; z: 100
             Component.onCompleted: { mainForm.visible = true; loadingRect.visible = false; }
         }

         // settings button of application
         MainButton {
             id: mainButton; height: topFrame.height; width: mainButton.height
             anchors { left: topFrame.left; top: topFrame.top }
             z: topFrame.z + 1 // before top frame
             onButtonClicked: { mainArea.menuChange(); }
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
                    case "CarView":
                        carView.area.enabled = menuView.currentIndex === 1 ? true : false
                        break
                    case "SettingsView":
                        break
                    case "DateChooser":
                        dateChooser.area.enabled = menuView.currentIndex === 1 ? true : false
                        break
                    case "RentView":
                        rentView.area.enabled = menuView.currentIndex === 1 ? true : false
                        break
                    case "BookingView":
                        bookingView.area.enabled = menuView.currentIndex === 1 ? true : false
                        break
                    case "CodesView":
                        codesView.area.enabled = menuView.currentIndex === 1 ? true : false
                        break

                 }
            }

             MenuView {
                 id:menuView
                 z: normalViewMask.z + 1 // before normalView
                 mainArea: mainArea
                 onItemClicked: {
                        if(idx === 0) { stackView.pop(null, StackView.Immediate) }
                        else if(idx === 1) { stackView.clear(); stackView.push(carView, StackView.Immediate, settingsView, StackView.Immediate) }
                        else { fileio.readCodes(); stackView.clear(); stackView.push(carView, StackView.Immediate, codesView, StackView.Immediate) }
                        mainArea.menuChange()
                        }
            } // Menu View

            Rectangle { id: normalView; anchors.fill: parent; visible: false
                 CarView { id:carView; objectName: "CarView"; Component.onCompleted: {
                         if(sqlDatabase.connectToDatabase("94.230.27.222", "sigmacars", "root", "Serwis4q@"))
                             carViewClass.setCarList()
                         else messageDialog.show("Błąd!", "Nie można połaczyć z serwerm.", StandardIcon.Critical);
                     }
                 }
                 SettingsView { id:settingsView; objectName: "SettingsView"; }
                 CodesView { id:codesView; objectName: "CodesView"; }
                 DateChooser {id:dateChooser; objectName: "DateChooser";}
                 RentView { id:rentView; objectName: "RentView"; }
                 PinView { id:pinView; objectName: "PinView" }
                 BookingView { id:bookingView; objectName: "BookingView" }
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
           }

         } // MainArea

    } // MainForm

} // ApplicationWindow

