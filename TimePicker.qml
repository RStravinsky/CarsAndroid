import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQml 2.2
import QtGraphicalEffects 1.0
import Qt.labs.controls 1.0

Item {
    id: timePicker
    anchors.fill: parent
    visible: hoursStackView.currentItem === timePicker ? true : false
    property var nextView
    property date startDateTime
    property string startDateTimeString
    property date endDateTime
    property string endDateTimeString
    property int hourIndex: 0
    property int whichDateTime // 0-start datetime, 1-end datetime
    property int listIndex

    function setListIndex(val)
    {
        listIndex = val
    }

    function setHourIndex(val)
    {
        hourIndex = val
        timeTumbler.setInitHourIndex(val)
    }

    function setDateTimeType(val)
    {
        whichDateTime = val
    }

    function clearTimePicker()
    {
        timeTumbler.clearTimeTumbler()
    }

    function setTimePicker(date, time)
    {
        timeTumbler.setTimeTumbler(date, time)
    }

    function clearDateTimeStrings()
    {
        startDateTimeString = ""
        endDateTimeString = ""
    }

        Rectangle {
                id: orangeBar
                color: "#FF8C00"
                width: parent.width
                height: parent.height * .2
                anchors {left: parent.left; top: parent.top; topMargin: 10; horizontalCenter: parent.horizontalCenter}

            Text {
                id: titleText
                height: Text.height
                text: "Wybierz godzinę:"
                color: "white"
                anchors {verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter}
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: defaultFontPixelSize * 1.2
            }
        }

        TimeTumbler {
            id: timeTumbler;
            anchors {top: orangeBar.bottom; topMargin: 5; horizontalCenter: parent.horizontalCenter;}
            width: parent.width
            height: parent.height * .5
        }

        ActionButton { id: nextBtn; width: nextBtn.height * 2.5; height: parent.height * .15
            anchors { right: parent.right; rightMargin: 10; bottom: parent.bottom; }
            buttonText: qsTr("Dalej")
            onActivated: {

                //carViewClass.carList[listIndex].readBookingEntries(bookingCalendar.selectedDate, timeTumbler.timeString)
                console.log("WHICH DATE TIME : ", whichDateTime)

                if(whichDateTime === 0) {
                    startDateTimeString = bookingCalendar.selectedDate.toLocaleString(Qt.locale("pl_PL"), "yyyy-MM-dd") + " " + timeTumbler.timeString
                    startDateTime = Date.fromLocaleString(Qt.locale(), startDateTimeString, "yyyy-MM-dd hh:mm")

                    console.log("startDateTimeString: ", startDateTimeString)
                    console.log("startDateTime: ", startDateTime)
                    console.log("endDateTimeString: ", endDateTimeString)
                    console.log("endDateTimeString: ", endDateTimeString)
                    console.log("currentDate: ", new Date())

                    if(startDateTime < new Date()) {
                        messageDialog.show("Uwaga!", "Wybrana data/godzina jest mniejsza od aktualnej.", StandardIcon.Warning, false)
                        return
                    }

                    if(carViewClass.carList[listIndex].isDateCorrect(startDateTime)) {

                        if(bookingView.bookingFields.getFields()[1] !== "") {
                            if(carViewClass.carList[listIndex].checkDates(startDateTime, endDateTime)) {}
                            else {
                                messageDialog.show("Uwaga!", "Godziny, które wybrałeś są już zarezerwowane.", StandardIcon.Warning, false)
                                startDateTimeString = ""
                                startDateTime = ""
                                return;
                            }
                        }

                        if((endDateTimeString !== "") && (startDateTime < endDateTime)) {
                            bookingView.bookingFields.bookingFieldsRepeater.itemAt(whichDateTime).customTextField.text = startDateTimeString
                            stackView.pop(bookingView)
                            dateChooserStack.pop(hoursListItem)

                        }
                        else if(endDateTimeString === ""){
                            bookingView.bookingFields.bookingFieldsRepeater.itemAt(whichDateTime).customTextField.text = startDateTimeString
                            stackView.pop(bookingView)
                            dateChooserStack.pop(hoursListItem)
                        }
                        else {
                            messageDialog.show("Uwaga!", "Niepoprawna godzina.", StandardIcon.Warning, false)
                            startDateTimeString = ""
                            startDateTime = ""
                        }
                    }
                    else {
                        messageDialog.show("Uwaga!", "Wybrana data/godzina jest już zarezerwowana.", StandardIcon.Warning, false)
                        startDateTimeString = ""
                        startDateTime = ""
                    }
                }
                else if(whichDateTime === 1) {
                    endDateTimeString = bookingCalendar.selectedDate.toLocaleString(Qt.locale("pl_PL"), "yyyy-MM-dd") + " " + timeTumbler.timeString
                    endDateTime = Date.fromLocaleString(Qt.locale(), endDateTimeString, "yyyy-MM-dd hh:mm")

                    console.log("startDateTimeString: ", startDateTimeString)
                    console.log("startDateTime: ", startDateTime)
                    console.log("endDateTimeString: ", endDateTimeString)
                    console.log("endDateTimeString: ", endDateTime)

                    if(endDateTime < new Date()) {
                        messageDialog.show("Uwaga!", "Wybrana data jest mniejsza od aktualnej.", StandardIcon.Warning, false)
                        return
                    }

                    if(carViewClass.carList[listIndex].isDateCorrect(endDateTime)) {
                        if(carViewClass.carList[listIndex].checkDates(startDateTime, endDateTime)) {
                            if(endDateTime > startDateTime) {
                                bookingView.bookingFields.bookingFieldsRepeater.itemAt(whichDateTime).customTextField.text = endDateTimeString
                                stackView.pop(bookingView)
                                dateChooserStack.pop(hoursListItem)
                            }
                            else {
                                messageDialog.show("Uwaga!", "Niepoprawna godzina.", StandardIcon.Warning, false)
                                endDateTimeString = ""
                                endDateTime = ""
                            }
                        }
                        else {
                            messageDialog.show("Uwaga!", "Godziny, które wybrałeś są już zarezerwowane.", StandardIcon.Warning, false)
                            endDateTimeString = ""
                            endDateTime = ""
                        }
                    }
                    else {
                       messageDialog.show("Uwaga!", "Wybrana godzina jest już zarezerwowana.", StandardIcon.Warning, false)
                        endDateTimeString = ""
                        endDateTime = ""
                    }
                }

            }
        }

} // Item

