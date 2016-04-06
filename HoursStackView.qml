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
    property var listIndex

    function setListIndex(val) {
        listIndex = val
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: hoursListItem

    }

    HoursListItem { id: hoursListItem; nextView: hourContentItem; selectedDate: dateChooser.calendar.selectedDate }
    HourContentItem { id: hourContentItem; nextView: startTimePicker }
    StartTimePicker { id: startTimePicker; nextView: endTimePicker }
    EndTimePicker { id: endTimePicker; nextView: hoursListItem }


}
