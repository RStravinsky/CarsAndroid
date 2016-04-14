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
        hoursList.currentIndex = -1
    }

    function setHoursListItem(date, time)
    {
        hoursList.currentIndex = (time.substr(0,2))*1
        console.log("setHoursListItem")
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
                anchors { left: parent.left; top: parent.top; topMargin: 5; bottom: parent.bottom; bottomMargin: 5 }
                height: parent.height
                width: 20
                color: {
                    switch(carViewClass.carList[listIndex].setHoursColor(dateChooser.calendar.selectedDate, modelData)) // TypeError
                    {
                    case 0: "#32b678"
                            break
                    case 1: "#3988e5"
                            break
                    case 2: "#db4437"
                            break
                    }
                }
            }

            Text { id: hour
                anchors { left: rec.right; leftMargin: 10; verticalCenter: parent.verticalCenter }
                color: "gray"; font.pointSize: 18; text: modelData
            }

            Rectangle { id: line
                anchors { left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; top: rec.bottom; topMargin: 5; }
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
                    enabled: menuView.currentIndex === 1 ? true : false
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
                            timePicker.clearTimePicker()
                            timePicker.setHourIndex(hoursList.currentIndex)
                            carViewClass.carList[listIndex].readBookingEntries(selectedDate, modelData)
                            hourState = carViewClass.carList[listIndex].setHoursColor(dateChooser.calendar.selectedDate, modelData)
                            dateChooserStack.push(nextView)
                        }
                    }
                }

            } // Rectangle

        } // Item

    } // Component

} // Item



