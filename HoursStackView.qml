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

    function setListIndex(val) {
        listIndex = val
    }

    Rectangle {
        anchors.fill:parent

        StackView {
            id: dateChooserStack
            anchors.fill: parent
            initialItem: hoursListItem
        }

        HoursListItem { id: hoursListItem; anchors.fill: parent; nextView: (hourState === 0) ? startTimePicker : hourContentItem; selectedDate: dateChooser.calendar.selectedDate }
        HourContentItem { id: hourContentItem; nextView: startTimePicker; isReserveButtonVisible: (hoursListItem.hourState === 2) ? false : true; }
        StartTimePicker { id: startTimePicker; nextView: endTimePicker }
        EndTimePicker { id: endTimePicker; nextView: hoursListItem }

    }

}
