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
    id: hoursListItem
    anchors.fill: parent
    visible: hoursStackView.currentItem === hoursListItem ? true : false
    property date selectedDate
    property var nextView
    property int hourState
    property var listofHours: hoursList

    function clearHoursListItem()
    {
        hoursList.currentIndex = 0
        hoursList.positionViewAtBeginning()
    }

    ListView {
        id: hoursList
        anchors.fill: parent
        model: ["00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"]
        delegate: hoursListDelegate
        highlightMoveDuration: 0
        highlight: Rectangle {color: "lightgray" }
        currentIndex: -1
        snapMode: ListView.SnapToItem
        clip: true
    }

    Component {
        id: hoursListDelegate

        Item { id: hlDItem; height: screenH * .1; width: parent.width;

            Rectangle { id: rec
                property int state: carViewClass.carList[listIndex].setHoursColor(dateChooser.calendar.selectedDate, modelData)
                anchors { left: parent.left; top: parent.top; topMargin: 5; bottom: parent.bottom; bottomMargin: 5 }
                height: parent.height
                width: 20
                color: state === 0 ? "#32b678" : (state === 1 ? "#3988e5" : "#db4437")
            }

            Text { id: hour
                anchors { left: rec.right; leftMargin: 10; verticalCenter: parent.verticalCenter }
                color: "gray"; font.pointSize: 7 * point; text: modelData
            }

            Rectangle { id: line
                anchors { left: parent.left; right: parent.right; top: rec.bottom; topMargin: 2; }
                height: 2
                width: parent.width
                color: "lightgray"
            }


           Rectangle {
                id: imageRectangle
                height: parent.height
                width: parent.width
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                color: "transparent"

                Image {
                    id: narrowButton
                    anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter }
                    source: "/images/images/right-angle-arrow.png"
                }

                MouseArea {
                    id: narrowButtonMouseArea
                    anchors.fill: parent
                    z: mouseM.z - 1
                    onClicked: {
                        hoursList.currentIndex = index
                        delay.running = true
                    }
                }

                PauseAnimation {
                    id: delay
                    duration: 100
                    onRunningChanged: {
                        if (delay.running) {}
                        else {
                            if(sqlDatabase.isOpen()) { // CHECK THIS !!!!!!!!!!!!!!!!!!!!!!
                                timePicker.clearTimePicker()
                                timePicker.setHourIndex(hoursList.currentIndex)
                                hourState = rec.state
                                carViewClass.carList[listIndex].updateBookingModel();
                                if(hourState != 0) carViewClass.carList[listIndex].readBookingEntries(selectedDate, modelData)
                                dateChooserStack.push(nextView)
                            }
                            else messageDialog.show("Uwaga!", "Błąd połaczenia.", StandardIcon.Warning, false);
                        }
                    }
                }

            } // Rectangle

        } // Item

    } // Component

} // Item



