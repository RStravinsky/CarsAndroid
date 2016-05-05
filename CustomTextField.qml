import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.3
import QtQuick.Dialogs 1.2

Item {
    id: customTextField
    property string placeholderText: ""
    property int horizontalAlignment: Text.AlignLeft
    property int maximumLength: 32767
    property bool customReturnKey: false
    property bool activeButton: false
    property int dateTimeType
    property bool warningVisible: false
    property int displayTextWay : TextInput.Normal

    property alias field: field
    property alias text: field.text
    property alias underlineColor: customBorder.color
    property alias inputMethodHints: field.inputMethodHints
    property alias validator: field.validator

    signal mouseAreaClicked()

    function clear() { field.text = "" }

    TextField {
        id: field
        anchors.fill:parent
        horizontalAlignment: customTextField.horizontalAlignment
        font.pointSize: 9 * point
        placeholderText: customTextField.placeholderText
        maximumLength: customTextField.maximumLength
        readOnly: customTextField.activeButton
        style: TextFieldStyle {
                textColor: "gray"
                placeholderTextColor: "lightgray"
                background: Rectangle { border.width: 0 }
        }

        Keys.onReturnPressed: {
            //console.log("Retrun pressed")
            event.accepted = customReturnKey // Dont accept the event (active focus kept).

            if(customReturnKey === true) {
                loadingRect.isLoading = true // enable loaidng
                if(carViewClass.carList[pinView.listIndex].isCodeCorrect(carViewClass.carList[pinView.listIndex].id,field.text)) {
                    if(carViewClass.carList[listIndex].updateHistory(rentView.returnFields.getFields(),rentView.distance))
                    {
                        fileio.removeCode(field.text)
                        Qt.inputMethod.hide() // show virtual keyboard
                        messageDialog.show("Oddano!", "Samochód został oddany.", StandardIcon.Information, true); // RELOAD APP
                    }
                    else { loadingRect.isLoading = false; messageDialog.show("Uwaga!", "Polecenie nie powiodło się.", StandardIcon.Warning, false); }
                }
                else { loadingRect.isLoading = false; messageDialog.show("Niepoprawny kod!", "Spróbuj ponownie.", StandardIcon.Warning, false); }
             }
        }

        Image {
            id: invalid
            anchors { top: parent.top; right: clearText.left; rightMargin: 5; verticalCenter: parent.verticalCenter }
            height: field.font.pointSize * 2.5
            width: field.font.pointSize * 2.5
            source: "/images/images/warning.png"
            fillMode: Image.PreserveAspectFit
            smooth: true;
            visible: warningVisible
        }

        Image {
            id: clearText
            anchors { top: parent.top; right: parent.right; verticalCenter: parent.verticalCenter }
            height: field.font.pointSize * 3.5
            width: field.font.pointSize * 3.5
            fillMode: Image.PreserveAspectFit
            smooth: true; visible: (field.text && field.focus === true)
            source: "/images/images/clear.png"

            MouseArea {
                id: clear
                anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
                height: field.height; width: field.height
                onClicked: {
                    field.text = ""
                    field.forceActiveFocus()
                }
            }

            Behavior on visible {
                NumberAnimation {
                    target: clearText
                    property: "opacity"
                    from: clearText.visible === false ? 0 : 1
                    to: clearText.visible === false ? 1 : 0
                    duration: 500
                    easing.type: Easing.InOutQuad
                }}
        }

        echoMode: displayTextWay

    } // TextField

    Rectangle {
         id: imageRectangle
         anchors.fill: parent
         color: "transparent"
         visible: customTextField.activeButton

         Image {
             id: narrowButton
             anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter }
             source: "/images/images/right-angle-arrow.png"
         }

         MouseArea {
             id: narrowButtonMouseArea
             anchors.fill: parent
             onClicked: {
                btnClickAnimation.running = true
             }
         }

         SequentialAnimation {
             id: btnClickAnimation
             PropertyAnimation { target: imageRectangle; property: "opacity"; easing.type: Easing.Linear; to: 0; duration: 10 }
             PropertyAnimation { target: imageRectangle; property: "opacity"; easing.type: Easing.Linear; to: 1; duration: 10 }
             onRunningChanged: {
                 if (btnClickAnimation.running) {}
                 else {
                     if(dateTimeType === 1 && bookingView.bookingFields.getFields()[0] === "") {
                        messageDialog.show("Informacja!", "Uzupełnij datę początkową.", StandardIcon.Information, false);
                     }
                     else {
                        loadingRect.text = "Wczytywanie\nkalendarza ..."
                        loadingRect.isLoading = true // enable loading
                        bookingView.area.enabled = false
                        bookingView.area.forceActiveFocus()

                        if(sqlDatabase.isOpen())
                        {
                            stackView.push(dateChooser)
                            dateChooser.clearDateChooser();
                            dateChooser.setDateTimeType(dateTimeType);

                            carViewClass.carList[bookingView.listIndex].updateBookingModel();
                            dateChooser.setListIndex(bookingView.listIndex);
                        }
                        else { messageDialog.show("Uwaga!", "Błąd połaczenia.", StandardIcon.Warning, false); }

                        loadingRect.isLoading = false
                        loadingRect.text = "Proszę czekać ..."
                        bookingView.area.enabled = true
                     }
                 }
             }
         }
    }

    Rectangle
    {
        id: customBorder
        z: -2
        color: field.focus === true ? "#69C0D9" : "lightgray"
        height: field.height
        width: field.width
        anchors { left: field.left; right: field.right; top: field.top; topMargin: 6}
    }

    Rectangle {
        z: customBorder.z + 1
        color: "white"
        height: customBorder.height - 6
        width: customBorder.width
        anchors
        {
            left: customBorder.left
            right: customBorder.right
            bottom: customBorder.bottom
            bottomMargin: 3
            leftMargin: 3
            rightMargin: 3
        }
    }

} // Item


