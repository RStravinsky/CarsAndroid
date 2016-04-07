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
    id: startTimePicker
    anchors.fill: parent
    visible: hoursStackView.currentItem === startTimePicker ? true : false
    property var nextView
    property date dateTime
    property string dateTimeString

        Rectangle {
                id: orangeBar
                color: "#FF6900"
                width: parent.width
                height: parent.height * .2
                anchors {left: parent.left; top: parent.top; topMargin: 10; horizontalCenter: parent.horizontalCenter}

            Text {
                id: titleText
                height: Text.height
                text: "Wybierz godzinę początkową:"
                color: "white"
                anchors {verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter}
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
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
            visible: isReserveButtonVisible
            buttonText: qsTr("Dalej")
            onActivated: {
                dateChooserStack.push(nextView)
                dateTimeString = bookingCalendar.selectedDate.toLocaleString(Qt.locale("pl_PL"), "yyyy-MM-dd") + " " + timeTumbler.timeString
                dateTime = Date.fromLocaleString(Qt.locale(), dateTimeString, "yyyy-MM-dd hh:mm")
            }
        }

} // Item

