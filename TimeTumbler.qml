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
    id: timeTumbler
    property var hours: ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    property var minutesH: ["0", "1", "2", "3", "4", "5"]
    property var minutesL: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    property int tumblerFontSize: 32
    property string timeString
    property var tumblerofHours: hoursTumbler

    function updateTimeString()
    {
        timeString = hours[hoursTumbler.currentIndex] + ":" + minutesH[minutesHTumbler.currentIndex] + minutesL[minutesLTumbler.currentIndex]

    }

    function setInitHourIndex(val)
    {
        hoursTumbler.currentIndex = val
    }

    function clearTimeTumbler()
    {
        hoursTumbler.currentIndex = 0
        minutesHTumbler.currentIndex = 0
        minutesLTumbler.currentIndex = 0
    }

    function setTimeTumbler(date, time)
    {
        console.log("hour: "+time.substr(0,2))
        console.log("minuteH: "+(time.substr(3,1))*1)
        console.log("minuteL: "+(time.substr(4,1))*1)

        hoursTumbler.currentIndex = (time.substr(0,2))*1
        minutesHTumbler.currentIndex = (time.substr(3,1))*1
        minutesLTumbler.currentIndex = (time.substr(4,1))*1
    }

    Rectangle {
        id: timeTumblerRectangle
        color: "white"
        anchors.fill: parent


        Tumbler {
            id: hoursTumbler
            anchors { left: parent.left; verticalCenter: parent.verticalCenter}
            width: parent.width * .266
            height: parent.height

            background: Rectangle {
                border.color: "lightgray"
                border.width: 3
            }

            contentItem: ListView {
                id: hList
                anchors {left: parent.left}
                width: parent.width
                model: hours
                delegate: Text {
                        id: textLabel
                        text: modelData
                        color: "#666666"
                        font.family: "Calibri"
                        font.bold: true
                        font.pointSize: tumblerFontSize
                        opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                snapMode: ListView.SnapToItem
                highlightRangeMode: ListView.StrictlyEnforceRange

                preferredHighlightBegin: height / 2 - (height / hoursTumbler.visibleItemCount / 2)
                preferredHighlightEnd: height / 2  + (height / hoursTumbler.visibleItemCount / 2)
                clip: true
                highlightMoveDuration: 0

            }

            onCurrentItemChanged: { updateTimeString(); }

        }

        Text {
            id: colonText
            height: hoursTumbler.height
            width: parent.width * .05
            text: ":"
            color: "#666666"
            font.family: "Calibri"
            font.bold: true
            font.pointSize: tumblerFontSize
            opacity: 1
            anchors {left: hoursTumbler.right; leftMargin: parent.width * .05; verticalCenter: hoursTumbler.verticalCenter}
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Tumbler {
            id: minutesHTumbler
            anchors { left: colonText.right; leftMargin: timeTumblerRectangle.width * .05; verticalCenter: hoursTumbler.verticalCenter; }//horizontalCenter: titleText.horizontalCenter }
            width: parent.width * .266
            height: hoursTumbler.height

            background: Rectangle {
                border.color: "lightgray"
                border.width: 3
            }

            contentItem: ListView {
                    id: mHList
                    anchors {left: parent.left; }
                    width: parent.width
                    model: minutesH
                    delegate: Text {
                            text: modelData
                            color: "#666666"
                            font.family: "Calibri"
                            font.bold: true
                            font.pointSize: tumblerFontSize
                            opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                    snapMode: ListView.SnapToItem
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    preferredHighlightBegin: height / 2 - (height / minutesHTumbler.visibleItemCount / 2)
                    preferredHighlightEnd: height / 2  + (height / minutesHTumbler.visibleItemCount / 2)
                    clip: true
                    highlightMoveDuration: 0
           }

            onCurrentItemChanged: { updateTimeString(); }

        }


        Tumbler {
            id: minutesLTumbler
            anchors { left: minutesHTumbler.right; leftMargin: parent.width * .05; verticalCenter: hoursTumbler.verticalCenter }
            width: parent.width * .266
            height: hoursTumbler.height

            background: Rectangle {
                border.color: "lightgray"
                border.width: 3
            }

            contentItem: ListView {
                    id: mLList
                    anchors {left: parent.left; }
                    width: parent.width
                    model: minutesL
                    delegate: Text {
                            text: modelData
                            color: "#666666"
                            font.family: "Calibri"
                            font.bold: true
                            font.pointSize: tumblerFontSize
                            opacity: 0.4 + Math.max(0, 1 - Math.abs(Tumbler.displacement)) * 0.6
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                    snapMode: ListView.SnapToItem
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    preferredHighlightBegin: height / 2 - (height / minutesLTumbler.visibleItemCount / 2)
                    preferredHighlightEnd: height / 2  + (height / minutesLTumbler.visibleItemCount / 2)
                    clip: true
                    highlightMoveDuration: 0
           }

            onCurrentItemChanged: { updateTimeString(); }

        }
    }

}
