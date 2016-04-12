import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.3

Item {
    id: bookingView
    property alias area: area
    property int listIndex
    property alias bookingFields: bookingFields

    function clearText() { bookingFields.clearText() }
    function setListIndex(val) { listIndex = val }

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
        id: loadingRect
        anchors.fill: parent
        z: bookingView.z + 1
        visible: bookingBtn.isActivated
        color:"black"
        opacity: 0.5
    }

    Rectangle {
        id: area
        property int offset: 20
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; top: parent.top; margins: offset }
        property int areaHeight: (screenH - topFrame.height - (2*offset))

        // car name
        Text { id: carName; width: parent.width; height: area.areaHeight* .07
            anchors.top: parent.top
            horizontalAlignment: Text.AlignHCenter
            text: carViewClass.carList[listIndex].brand + " " + carViewClass.carList[listIndex].model
            font.pixelSize: area.areaHeight/20
            color: "gray"
        }

        // car image
        Image { id: carImage; width: parent.width; height: area.areaHeight* .25
            anchors { top: carName.bottom; left: parent.left; right: parent.right; topMargin: 5; rightMargin: 60; leftMargin: 60 }
            source: carViewClass.carList[listIndex].photoPath !== "" ? "images/" + carViewClass.carList[listIndex].photoPath : ""
            fillMode: Image.PreserveAspectFit
        }

        // text fields
        BookingFields { id: bookingFields; width: parent.width; height:  area.areaHeight * .55
            anchors { top: carImage.bottom; topMargin: 5 }
        }

        // rent/return button
        ActionButton { id: bookingBtn; width: parent.width; height: area.areaHeight * .13;
            property string code
            property int distance
            anchors { bottom: parent.bottom; left: parent.left; right: parent.right; }
            buttonText: qsTr("Rezerwuj")
            enabled: menuView.currentIndex === 1 ? true : false
            fontSize: screenH/35
            z: bookingView.z + 1 // before parent

            onActivated: {
                if(bookingFields.dataIsEmpty()) {
                    messageDialog.show("Uwaga!", "Pole tekstowe nie zostało wypełnione.", StandardIcon.Warning);
                }
                else {
                    if(carViewClass.carList[listIndex].addToBooking(bookingFields.getFields()))
                    { messageDialog.show("Informacja!", "Samochód został zarezerwowany.", StandardIcon.Information); bookingFields.clearText(); apps.reloadWindow();  stackView.pop() }
                    else { messageDialog.show("Uwaga!", "Polecenie nie powiodło się.", StandardIcon.Warning) }
                }

                bookingBtn.isActivated = false
            } // OnActivated

        } // ActiveButton

    } // Rectangle

} // Item
