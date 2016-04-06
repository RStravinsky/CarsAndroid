import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import Qt.labs.controls 1.0
import QtGraphicalEffects 1.0
import QtQuick.Window 2.2

ApplicationWindow {
    id: apps
    visible: true
    visibility:  "Maximized"
    title: qsTr("Rezerwacja")
    Keys.enabled: true
    Keys.priority: Keys.BeforeItem

    property int screenH: Screen.height
    property int screenW: Screen.width

    MainForm {
         id: mainForm
         anchors.fill: parent

         focus: true // important - otherwise we'll get no key events
         Keys.onReleased: {
             if (event.key === Qt.Key_Back) {
                 if(menuView.currentIndex === 1) { // menu not visible
                     if(stackView.currentItem.objectName === "SettingsView") { menuView.list.currentIndex = 0 }
                     if(stackView.depth === 1) apps.close()
                     else stackView.pop()
                 }
                 else { mainArea.menuChange() }
                 event.accepted = true
             }
         }

         /* top frame of application */
         TopFrame { id: topFrame; width: mainForm.width; height: screenH * 0.1; anchors.top: mainForm.top; z: 100 }

         /* settings button of application */
         MainButton {
             id: mainButton; width: mainButton.height; height: topFrame.height
             anchors { left: topFrame.left; top: topFrame.top }
             z: topFrame.z + 1 // before top frame
             onButtonClicked: { mainArea.menuChange(); }
         }

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
                        carView.list.interactive = menuView.currentIndex === 1 ? true : false
                        break
                    case "SettingsView":
                        break
                    case "DateChooser":
                        dateChooser.calendar.enabled = menuView.currentIndex === 1 ? true : false
                        //dateChooser.list.interactive = menuView.currentIndex === 1 ? true : false
                        break
                 }
            }

             MenuView {
                 id:menuView
                 z: normalViewMask.z + 1 // before normalView
                 mainArea: mainArea
                 onItemClicked: {
                        if(idx === 0) { stackView.pop(null, StackView.Immediate) }
                        else { stackView.clear(); stackView.push(carView, StackView.Immediate, settingsView, StackView.Immediate) }
                        mainArea.menuChange()
                        }
             } // Menu View



            Rectangle { id: normalView; anchors.fill: parent; visible: false
                 CarView { id:carView; anchors.fill: normalView; objectName: "CarView"; Component.onCompleted: carViewClass.setCarList()}
                 SettingsView { id:settingsView; objectName: "SettingsView";}
                 DateChooser {id:dateChooser; objectName: "DateChooser";}

            } // Normal View

            /* view mask */
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


         } // Main Area

    } // Main Form

} // Application Window

