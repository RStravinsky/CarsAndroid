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
    id: endTimePicker
    anchors.fill: parent
    visible: stackView.currentItem === endTimePicker ? true : false
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
                text: "Wybierz godzinę końcową:"
                color: "white"
                font.family: "Calibri"
                //font.bold: true
                opacity: 1
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

        Button {
            id: backBtn
            width: backBtn.height * 2.5
            height: parent.height * .15
            anchors { left: parent.left; leftMargin: 10; bottom: parent.bottom; }

            background: Rectangle {
                id: btnRec
                property color gradcolorStart: "#FF8C00"
                property color gradcolorEnd: "#FF6900"
                anchors.fill: parent

                gradient: Gradient {
                    GradientStop { position: 0; color: btnRec.gradcolorStart }
                    GradientStop { position: 1; color: btnRec.gradcolorEnd }
                    }
                radius: 5
                opacity: backBtn.pressed ? 0 : 1
            }

            label: Label {
                id: btnLab
                text: "Cofnij"
                color: "white"
                font.family: "Calibri"
                font.pointSize: 12
                anchors.horizontalCenter: backBtn.horizontalCenter
                anchors.verticalCenter: backBtn.verticalCenter

            }

            onClicked: {
                stackView.pop()
            }
        }

        Button {
            id: nextBtn
            width: nextBtn.height * 2.5
            height: parent.height * .15
            anchors { right: parent.right; rightMargin: 10; bottom: parent.bottom; }

            background: Rectangle {
                id: btnNextRec
                anchors.fill: parent

                gradient: Gradient {
                    GradientStop { position: 0; color: btnRec.gradcolorStart }
                    GradientStop { position: 1; color: btnRec.gradcolorEnd }
                    }
                radius: 5
                opacity: nextBtn.pressed ? 0 : 1
            }

            label: Label {
                id: btnNextLab
                text: "Kontynuuj"
                color: "white"
                font.family: "Calibri"
                font.pointSize: 12
                anchors.horizontalCenter: nextBtn.horizontalCenter
                anchors.verticalCenter: nextBtn.verticalCenter

            }

            onClicked: {
                stackView.push(nextView)
                dateTimeString = bookingCalendar.selectedDate.toLocaleString(Qt.locale("pl_PL"), "yyyy-MM-dd") + " " + timeTumbler.timeString
                //console.log(dateTimeString)
                dateTime = Date.fromLocaleString(Qt.locale(), dateTimeString, "yyyy-MM-dd hh:mm")
                //console.log(dateTime)
            }
        }

}

