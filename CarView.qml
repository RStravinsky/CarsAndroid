import QtQuick 2.5

Item {
    id: carView
    property var list: carList

    Component {
        id: carDelegate
        Item { id: carItem; height: 200; width: parent.width; property string sourceImage: (status === false)? "images/images/free.png" : "images/images/rented.png";

            Text { id: carName
                anchors { left: parent.left; leftMargin: 10; top: parent.top;}
                color: "gray"; font.pixelSize: 32;text: brand + " " + model
            }
            Text { id: license
                anchors { left: parent.left; leftMargin: 10; top: carName.bottom;}
                color: "gray"; font.pixelSize: 22; text: licensePlate
            }
            Image { id: carImage; height: carItem.height * .6;
                fillMode: Image.PreserveAspectFit
                source: "images/"+photoPath
                anchors { left: parent.left; top: license.bottom; topMargin: 5 }
            }
            Image { id: statusImage;
                fillMode: Image.PreserveAspectFit
                source: sourceImage
                anchors { left: parent.left; top: carName.bottom; topMargin: 5; leftMargin: carItem.width-100; right: parent.right; rightMargin: 10 }
            }

            ActionButton {
                id: rsrvBtn; height: carItem.height * .25; width: rsrvBtn.height * 2.5;
                buttonText: qsTr("Rezerwuj")
                anchors { bottom: carImage.bottom; right: statusImage.right }
                enabled: menuView.currentIndex === 1 ? true : false
                z: carView.z + 1 // before parent
                onActivated: { bookingView.setListIndex(listIndex); stackView.push(bookingView) }
            }


            ActionButton {
                id: rentBtn; height: carItem.height * .25; width: rsrvBtn.height * 2.5;
                gradcolorStart: "#00BE00"
                gradcolorEnd: "#009600"
                buttonText: qsTr("Wypożycz")
                anchors { bottom: carImage.bottom; right: rsrvBtn.left; rightMargin: 5 }
                enabled: menuView.currentIndex === 1 ? true : false
                z: carView.z + 1 // before parent
                //onActivated: { stackView.push(bookingView) }
            }


            Rectangle { height: 2; width: parent.width * 0.70;
                anchors { left: parent.left; leftMargin: 5; horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
                color: "lightgray";
            }

       } // Item

    } // Component

    ListView {
       id: carList
       anchors.fill: parent
       model: carViewClass.carList
       delegate: carDelegate
       highlightMoveDuration: 0

       SwipeArea {
           id: mouse
           menu: menuView
           anchors.fill: parent
           onMove: {
               carList.interactive = false
               //console.log("onMove...")
               carList.interactive = false
               menuView.x = (-mainArea.width * menuView.currentIndex) + x // changing menu x
               normalViewMask.opacity = (1 -((Math.abs(menuView.x)/menuView.width)))/1.5 // changing normal view opacity
           }
           onSwipe: {
               //console.log("onSwipe...")
               mainArea.menuChange()
           }
           onCanceled: {
               //console.log("onCanceled...")
               menuView.currentIndexChanged()
               normalViewMask.opacity = menuView.currentIndex === 1 ? 0 : 0.7
               carList.interactive = true
           }
       }
    }

}

