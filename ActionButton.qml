import QtQuick 2.5
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.3

Rectangle {
    id: actionButton
    property color buttonColor: "#FF8C00"
    property string buttonText
    property int fontSize: 7 * point
    signal activated()
    property bool isActivated: false;
    color : actionButton.buttonColor
    radius: 5

    Text {
        id: btnText
        anchors.horizontalCenter: actionButton.horizontalCenter
        anchors.verticalCenter: actionButton.verticalCenter
        text: actionButton.buttonText
        font.pointSize: actionButton.fontSize
        color: "white"
    }

    MouseArea {
        id: mouseArea;
        anchors.fill: actionButton
        onClicked: {
            console.log("ACTION")
            Qt.inputMethod.hide()
            btnClickAnimation.running = true
        }
        onDoubleClicked: mouse.accepted = false;
    }

    SequentialAnimation {
        id: btnClickAnimation
        PropertyAnimation { target: actionButton; property: "opacity"; easing.type: Easing.Linear; to: 0; duration: 10 }
        PropertyAnimation { target: actionButton; property: "opacity"; easing.type: Easing.Linear; to: 1; duration: 10 }
        onRunningChanged: {
            if (btnClickAnimation.running) {}
            else { actionButton.activated() }
        }
    }

 } // Rectangle
