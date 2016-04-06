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
    visible: stackView.currentItem === hoursListItem ? true : false
    property date selectedDate
    property var nextView

    ListView {
        id: hoursList
        anchors.fill: parent
        model: ["00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"]
        delegate: hoursListDelegate
    }

    Component {
        id: hoursListDelegate


        Item { id: hlDItem; height: screenH * .1; width: parent.width;

            Rectangle { id: rec
                anchors { left: parent.left; top: parent.top; topMargin: 5; bottom: parent.bottom; bottomMargin: 5 }
                height: parent.height
                width: 20
                color: {
                    switch(carViewClass.carList[listIndex].setHoursColor(dateChooser.calendar.selectedDate, modelData))
                    {
                    case 0: "green"
                            break
                    case 1: "blue"
                            break
                    case 2: "red"
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
                color: "transparent"
                width: narrowButton.width * 3
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }

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
                        carViewClass.carList[listIndex].readBookingEntries(selectedDate, modelData)
                        stackView.push(nextView)

                    }
                }
          }

       } // Item

    } // Component

}



