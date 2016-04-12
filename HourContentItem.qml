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
    id: hourContentItem
    visible: dateChooserStack.currentItem === hourContentItem ? true : false
    property var nextView
    property bool isReserveButtonVisible : true

    Rectangle {
        id: hourContent
        color: "white"
        anchors.fill: parent

        ListView {
            id: entriesList
            anchors {left: parent.left; right: parent.right; top: parent.top; bottom: nextBtn.top; bottomMargin: 10}
            model: { if(carViewClass.carList.length) carViewClass.carList[listIndex].bookingInfoList; }
            delegate: entriesListDelegate
        }

        Component {
            id: entriesListDelegate
            Item { id: elDItem; height: nextBtn.height * 1.5; width: parent.width;

                Rectangle { id: orangeRectangle
                    anchors { left: parent.left; leftMargin: 10; top: parent.top; topMargin: 5; verticalCenter: personName.verticalCenter}
                    height: 20
                    width: 20
                    color: "#FF6900"
                }

                Text { id: personName
                    anchors { left: orangeRectangle.right; leftMargin: 10; top: parent.top; topMargin: 5}
                    color: "gray"; font.pointSize: 18;text: name + " " + surname
                }

                Text { id: reservedHours
                    anchors { left: personName.left; top: personName.bottom; topMargin: 5}
                    color: "gray"; font.pointSize: 16; text: from + " - " + to
                }

                Rectangle { id: line
                    anchors { left: parent.left; leftMargin: 10; top: reservedHours.bottom; topMargin: 5; horizontalCenter: parent.horizontalCenter}
                    height: 2
                    width: parent.width
                    color: "lightgray"
                }


           } // Item

        } // Component

        ActionButton { id: nextBtn; width: nextBtn.height * 2.5; height: parent.height * .15
            anchors { right: parent.right; rightMargin: 10; bottom: parent.bottom; }
            visible: isReserveButtonVisible
            buttonText: qsTr("Rezerwuj")
            onActivated: {timePicker.setHourIndex(hoursListItem.listofHours.currentIndex); dateChooserStack.push(nextView)}
        }

    } // Rectangle

} // Item
