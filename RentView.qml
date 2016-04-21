import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.3

Item {
    id: rentView
    property alias area: area
    property int listIndex
    property var isRented : carViewClass.carList[listIndex].isRented
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
        id: area
        property int offset: 20
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; top: parent.top; margins: offset }
        property int areaHeight: (screenH - topFrame.height - (2*offset))
        enabled: (loadingRect.isLoading === true) ? false : true

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
            source: "image://cImages/"+carViewClass.carList[listIndex].id //carViewClass.carList[listIndex].photoPath !== "" ? "images/" + carViewClass.carList[listIndex].photoPath : ""
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
            fontSize: 16 * point //(screenH/(35*ratioFont)) //-------------------------------------
            z: rentView.z + 1 // before parent

            Connections {
                target: fileio
                onError: { loadingRect.isLoading = false; messageDialog.show("Uwaga!", msg, StandardIcon.Warning, false) }
            }

            onActivated: {
                area.forceActiveFocus() // disable focus from fields
                if((rentFields.dataIsEmpty() && rentView.isRented === false) || (returnFields.dataIsEmpty() && rentView.isRented === true)) {
                    messageDialog.show("Uwaga!", "Pole tekstowe nie zostało wypełnione.", StandardIcon.Warning,false);
                }
                else {
                    if(rentView.isRented === false) { // rent car
                        loadingRect.isLoading = true // enable loading
                        code = carViewClass.generateCode()
                        if(carViewClass.carList[listIndex].addToHistory(rentFields.getFields(),code)) {
                            if(fileio.writeCode(code,carViewClass.carList[listIndex].brand + " " + carViewClass.carList[listIndex].model)) {  
                                messageDialog.show("Wypożyczono!", "Twój kod dostępu: " + code, StandardIcon.Information, true); // RELOAD APP
                            }
                        }
                        else { loadingRect.isLoading=false; messageDialog.show("Uwaga!", "Polecenie nie powiodło się.", StandardIcon.Warning,false); }
                    }
                    else // return car
                    {
                        distance = returnFields.getDistance()
                        if(distance === -1)
                            messageDialog.show("Uwaga!", "Wpisany przebieg nie jest większy od poprzedniego.", StandardIcon.Warning,false);
                        else {
                              pinView.setListIndex(listIndex)
                              stackView.push(pinView, stackView.Immediate)
                              Qt.inputMethod.show() // show virtual keyboard
                              pinView.field.forceActiveFocus() // set focus on text field
                        }
                    }
                }
            } // OnActivated

        } // ActiveButton

    } // Rectangle

} // Item
