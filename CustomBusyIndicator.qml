import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

BusyIndicator {
    id: busy
    property int bLines: 11
    property real bLength: 10 // % of the width of the control
    property real bWidth: 5 // % of the height of the control
    property real bRadius: 13 // % of the width of the control
    property real bCorner: 1 // between 0 and 1
    property real bSpeed: 100 // smaller is faster
    property real bTrail: 0.6 // between 0 and 1
    property bool bClockWise: true

    property real bOpacity: 0.7
    property string bColor: "#7B756B"
    property string bHighlightColor: "white"
    property string bBgColor: "transparent"

    style: CustomBusyIndicatorStyle {
        lines: control.bLines
        length: control.bLength
        width: control.bWidth
        radius: control.bRadius
        corner: control.bCorner
        speed: control.bSpeed
        trail: control.bTrail
        clockWise: control.bClockWise
        opacity: control.bOpacity
        color: control.bColor
        highlightColor: control.bHighlightColor
        bgColor: control.bBgColor
    }
}
