import QtQuick 2.5
import QtQuick.Dialogs 1.2

Item {
    id: carView
    anchors.fill: parent
    property alias area: area
    property alias list: carList

    SwipeArea {
        id: mouse
        menu: menuView
        anchors.fill: parent
        onMove: {
            //console.log("onMove")
            area.enabled = false
            menuView.x = (-mainArea.width * menuView.currentIndex) + x // changing menu x
            normalViewMask.opacity = (1 -((Math.abs(menuView.x)/menuView.width)))/1.5 // changing normal view opacity
        }
        onSwipe: {
            //console.log("onSwipe")
            mainArea.menuChange()
        }
        onCanceled: {
            //console.log("onCanceled")
            menuView.currentIndexChanged()
            normalViewMask.opacity = menuView.currentIndex === 1 ? 0 : 0.7
            area.enabled = menuView.currentIndex === 1 ? true : false
        }
    }

    Keys.onReturnPressed: {
        //console.log("Retrun pressed")
        carList.forceActiveFocus()
        event.accepted = true
    }

    Rectangle {
        id: area
        property int offset: 20
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; top: parent.top; margins: offset; topMargin: 0 }
        property int areaHeight: (screenH - topFrame.height - (2*offset))
        property var historyInfo
        visible: carViewClass.isBusy === true ? false : true

        // search field
        SearchField { id: searchField; width: parent.width; height: area.areaHeight*.1;
            anchors { top: parent.top; right: parent.right; left: parent.left; }
            z: carList.z + 1
        }

        Rectangle {
            width: parent.width; height: area.areaHeight*.9;
            anchors { top: searchField.bottom; right: parent.right; left: parent.left; bottom: parent.bottom; bottomMargin: Qt.inputMethod.visible === true ? Qt.inputMethod.keyboardRectangle.height : 0 }
            ListView {
               id: carList
               anchors.fill: parent
               model: carViewClass.carList
               highlightMoveDuration: 0
               delegate: Component {
                   id: carDelegate
                   Item { id: carItem; height: area.areaHeight*.3; width: parent.width;

                       Text { id: carName; height: parent.height * .15
                           anchors { left: parent.left; leftMargin: 5; top: parent.top; right: infoImage.left}
                           color: "gray"; font.pointSize: 9 * point
                           text: brand + " " + model
                       }
                       Text { id: license; height: parent.height * .1
                           anchors { left: parent.left; leftMargin: 5; top: carName.bottom;}
                           color: "gray"; font.pointSize: 8 * point
                           text: licensePlate
                       }
                       Image { id: carImage; height: parent.height * .5 * imageRatio
                           cache: true
                           fillMode: Image.PreserveAspectFit
                           source: { "image://cImages/"+id }
                           anchors { left: parent.left; top: license.bottom; topMargin: 5; right: rentBtn.left; rightMargin: 5; bottom: parent.bottom }
                       }
                       Image { id: infoImage; height: carName.height + license.height; width: height
                           anchors { right: parent.right; top: parent.top; topMargin: 5; }
                           fillMode: Image.PreserveAspectFit
                           cache: true
                           mipmap: true
                           smooth: true
                           antialiasing: true
                           source: "/images/images/info.png"
                           visible: isRented === false ? false : true

                           MouseArea {
                               anchors.fill:parent
                               visible: carViewClass.isBusy === true ? false : true
                               onClicked: { infoClickAnimation.running = true }
                           }

                           SequentialAnimation {
                               id: infoClickAnimation
                               PropertyAnimation { target: infoImage; property: "opacity"; easing.type: Easing.Linear; to: 0; duration: 10 }
                               PropertyAnimation { target: infoImage; property: "opacity"; easing.type: Easing.Linear; to: 1; duration: 10 }
                               onRunningChanged: {
                                   if (infoClickAnimation.running) {}
                                   else {
                                       area.historyInfo = carViewClass.carList[listIndex].historyInfoList
                                       messageDialog.show("Dane użytkownika","Imię: "+area.historyInfo[0]+"\n"+
                                                                             "Nazwisko: "+area.historyInfo[1]+"\n"+
                                                                             "Lokalizacja: "+area.historyInfo[2]+"\n"+
                                                                             "Cel wizyty: "+area.historyInfo[3]+"\n",
                                                          StandardIcon.Information, false)

                                   }
                               }
                           }
                       }
                       ActionButton {
                           id: rsrvBtn; height: carItem.height * .3; width: rsrvBtn.height * 1.7
                           buttonText: qsTr("Rezerwuj")
                           anchors { bottom: parent.bottom; bottomMargin: 10; right: parent.right }
                           onActivated: {
                               bookingView.setListIndex(listIndex);
                               bookingView.bookingFields.setPersonalData(sqlDatabase.settingsParameter[4], sqlDatabase.settingsParameter[5]);
                               stackView.push(bookingView);
                           }
                       }

                       ActionButton {
                           id: rentBtn; height: parent.height * .3; width: rsrvBtn.height * 1.7;
                           buttonColor: isRented === false ? "#32b678" : "#db4437"
                           buttonText: isRented === false ? qsTr("Wypożycz") : qsTr("Oddaj")
                           anchors { bottom: parent.bottom; bottomMargin: 10; right: rsrvBtn.left; rightMargin: 5 }
                           onActivated: {
                               rentView.setListIndex(listIndex);
                               rentView.rentFields.setPersonalData(sqlDatabase.settingsParameter[4], sqlDatabase.settingsParameter[5]);
                               stackView.push(rentView);
                           }
                       }

                       Rectangle { height: 2; width: parent.width;
                           anchors { left: parent.left; horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
                           color: "lightgray";
                       }

                  } // Item

               } // Component

            } // ListView

        } // Rectangle

    } // Rectangle

} // Item

