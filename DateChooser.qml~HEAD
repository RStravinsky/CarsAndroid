import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQml 2.2
import QtGraphicalEffects 1.0

Item {
    id: dateChooser
    anchors.fill: parent
    property int listIndex
    property var calendar: bookingCalendar
    property alias defaultFontPixelSize: hiddenText.font.pixelSize

    function setListIndex(val) {
        listIndex = val
    }

    Text {id: hiddenText}

    Rectangle {
        id: mainRectangle
        anchors.fill: parent
        color: "white"

        Calendar {
           id: bookingCalendar
           anchors.top: parent.top
           anchors.horizontalCenter: parent.horizontalCenter
           width: parent.width
           height: parent.height * 0.5
           z: hoursList.z + 1

           style: CalendarStyle {

               gridVisible: false
               background: Rectangle {color: "white";}
               navigationBar: Rectangle {
                          color: "#FF6900"
                          height: dateText.height * 2

                          ToolButton {
                              id: previousMonth
                              width: parent.height
                              height: width
                              anchors.verticalCenter: parent.verticalCenter
                              anchors.left: parent.left
                              iconSource: "/images/images/left-angle-arrow.png"
                              onClicked: control.showPreviousMonth()
                          }
                          Label {
                              id: dateText
                              text: styleData.title
                              font.pixelSize: defaultFontPixelSize * 1.2
                              horizontalAlignment: Text.AlignHCenter
                              verticalAlignment: Text.AlignVCenter
                              fontSizeMode: Text.Fit
                              anchors.verticalCenter: parent.verticalCenter
                              anchors.left: previousMonth.right
                              anchors.leftMargin: 2
                              anchors.right: nextMonth.left
                              anchors.rightMargin: 2
                          }
                          ToolButton {
                              id: nextMonth
                              width: parent.height
                              height: width
                              anchors.verticalCenter: parent.verticalCenter
                              anchors.right: parent.right
                              iconSource: "/images/images/right-angle-arrow.png"
                              onClicked: control.showNextMonth()
                          }
               }

               dayDelegate: Rectangle {
                   border.width: styleData.selected ? 3 : 1;
                   border.color: styleData.selected ? "black" : "lightgray"
                   color:  (carViewClass.carList[listIndex].isDateReserved(styleData.date)) ? "darkorange" : "white";
                   Label {
                       text: styleData.date.getDate()
                       anchors.centerIn: parent

                       readonly property color sameMonthDateTextColor: "#444"
                       readonly property color selectedDateTextColor: "#111"
                       readonly property color differentMonthDateTextColor: "#bbb"
                       readonly property color invalidDatecolor: "#dddddd"

                       color: {
                           var color = invalidDatecolor;
                           if (styleData.valid) {
                               // Date is within the valid range.
                               color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                               if (styleData.selected) {
                                   color = selectedDateTextColor;
                               }
                           }
                           color;
                       }
                   }

               }

           } // CalendarStyle
           onClicked: carViewClass.carList[listIndex].readBookingEntries(date)
        }

        ListView {
            id: hoursList
            width: parent.width
            height: parent.height * 0.5
            anchors.top: calendar.bottom
            topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            model: carViewClass.carList[listIndex].bookingInfoList
            delegate: hoursListDelegate
            //boundsBehavior: Flickable.StopAtBounds
        }

        Component {
            id: hoursListDelegate
            Item { id: hlDItem; height: 125; width: parent.width;

                Rectangle { id: rec
                    anchors { left: parent.left; leftMargin: 10; top: parent.top; topMargin: 5; verticalCenter: personName.verticalCenter}
                    height: 20
                    width: 20
                    color: "#FF6900"
                    radius: 10
                }

                Text { id: personName
                    anchors { left: rec.right; leftMargin: 10; top: parent.top; topMargin: 5}
                    color: "gray"; font.pointSize: 18;text: name + " " + surname
                }

                Text { id: reservedHours
                    anchors { left: personName.left; top: personName.bottom; topMargin: 5}
                    color: "gray"; font.pointSize: 16; text: from + " - " + to
                }

                Rectangle { id: line
                    anchors { left: parent.left; leftMargin: 10; top: reservedHours.bottom; topMargin: 5; horizontalCenter: parent.horizontalCenter}
                    height: 2
                    width: parent.width * 0.7
                    color: "lightgray"
                }


           } // Item

        } // Component

    } // Rectangle

} // Item
