import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.3

Item {
    id: rentView
    property alias area: area
    property int listIndex
    property var isRented : carViewClass.carList[listIndex].status
    property alias returnFields: returnFields
    property alias distance: rentBtn.distance

    function clearText() { rentFields.clearText(); returnFields.clearText() }
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
        z: rentBtn.z + 1
        color:"black"
        opacity: 0.5
        visible: rentBtn.isActivated
    }

    Rectangle {
        id: area
        property int offset: 20
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; top: parent.top; margins: offset }
        property int areaHeight: (screenH - topFrame.height - (2*offset))
        opacity: carViewClass.carList[listIndex].busy ? 0.5 : 1
        enabled: carViewClass.carList[listIndex].busy ? false : true

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
        RentFields { id: rentFields; width: parent.width; height:  area.areaHeight * .55
            anchors { top: carImage.bottom; topMargin: 5 }
            visible: rentView.isRented === false ? true: false; // Visible when car is free
        }

        ReturnFields { id: returnFields; width: parent.width; height: area.areaHeight * .55
            anchors { top: carImage.bottom; topMargin: 5 }
            visible: rentView.isRented === false ? false: true; // Visible when car is busy
        }

        // rent/return button
        ActionButton { id: rentBtn; width: parent.width; height: area.areaHeight * .13;
            property string code: ""
            property int distance: 0
            anchors { bottom: parent.bottom; left: parent.left; right: parent.right; }
            buttonColor: rentView.isRented === false ? "#32b678" : "#db4437"
            buttonText: rentView.isRented === false ? qsTr("Wypożycz") : qsTr("Oddaj")
            enabled: menuView.currentIndex === 1 ? true : false
            fontSize: screenH/35
            z: rentView.z + 1 // before parent

            Connections {
                target: fileio
                onError: { messageDialog.show("Uwaga!", msg, StandardIcon.Warning) }
            }

            onActivated: {
                if((rentFields.dataIsEmpty() && rentView.isRented === false) || (returnFields.dataIsEmpty() && rentView.isRented === true)) {
                    messageDialog.show("Uwaga!", "Pole tekstowe nie zostało wypełnione.", StandardIcon.Warning);
                }
                else {
                    if(rentView.isRented === false) { // rent car
                        code = carViewClass.generateCode()
                        if(carViewClass.carList[listIndex].addToHistory(rentFields.getFields(),code)) {
                            if(fileio.writeCode(code,carViewClass.carList[listIndex].brand + " " + carViewClass.carList[listIndex].model)) {
                                messageDialog.show("Wypożyczono!", "Twój kod dostępu: " + code, StandardIcon.Information);
                                stackView.pop()
                            }
                        }
                        else { messageDialog.show("Uwaga!", "Polecenie nie powiodło się.", StandardIcon.Warning) }
                    }
                    else // return car
                    {
                        distance = returnFields.getDistance()
                        if(distance === -1)
                            messageDialog.show("Uwaga!", "Wpisany przebieg nie jest większy od poprzedniego.", StandardIcon.Warning);
                        else {
                              pinView.setListIndex(listIndex)
                              stackView.push(pinView, stackView.Immediate)
                              Qt.inputMethod.show() // show virtual keyboard
                              pinView.field.forceActiveFocus() // set focus on text field
                        }
                    }
                }

                rentBtn.isActivated = false;
            } // OnActivated

        } // ActiveButton

    } // Rectangle

} // Item
