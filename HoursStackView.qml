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
    id: hoursStackView
    property var list: hoursListItem
    property int listIndex : 0
    property alias stack: dateChooserStack
    property string choosenDateTime: timePicker.whichDateTime === 0 ? timePicker.startDateTimeString : timePicker.endDateTimeString

    function setListIndex(val) {
        listIndex = val
    }

    function setDateTimeType(val)
    {
        timePicker.setDateTimeType(val)
    }

    function clearHoursStackView()
    {
        hoursListItem.clearHoursListItem()
        timePicker.clearTimePicker()
    }

    Rectangle {
        anchors.fill:parent

        StackView {
            id: dateChooserStack
            anchors.fill: parent
            initialItem: hoursListItem
        }

        HoursListItem { id: hoursListItem; anchors.fill: parent; nextView: (hourState === 0) ? timePicker : hourContentItem; selectedDate: dateChooser.calendar.selectedDate; }
        HourContentItem { id: hourContentItem; nextView: timePicker; isReserveButtonVisible: (hoursListItem.hourState === 2) ? false : true; }
        TimePicker { id: timePicker; nextView: hoursListItem }

    }

}
