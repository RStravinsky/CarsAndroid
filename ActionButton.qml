import QtQuick 2.5
import QtGraphicalEffects 1.0

Rectangle {
    id: actionButton
    property color gradcolorStart: "#FF8C00"
    property color gradcolorEnd: "#FF6900"
    property string buttonText
    signal activated()

    gradient: Gradient {
        GradientStop { position: 0; color: actionButton.gradcolorStart }
        GradientStop { position: 1; color: actionButton.gradcolorEnd }
        }
    radius: 5

    Text {
        id: btnText
        anchors.horizontalCenter: actionButton.horizontalCenter
        anchors.verticalCenter: actionButton.verticalCenter
        text: actionButton.buttonText
        font.family: "Calibri"
        font.pointSize: 11
        color: "white"
    }

    MouseArea {
        id: mouseArea;
        anchors.fill: actionButton
        onClicked: btnClickAnimation.running = true
    }

    SequentialAnimation {
        id: btnClickAnimation
        PropertyAnimation { target: actionButton; property: "opacity"; easing.type: Easing.Linear; to: 0; duration: 30 }
        PropertyAnimation { target: actionButton; property: "opacity"; easing.type: Easing.Linear; to: 1; duration: 30 }
        onRunningChanged: {
            if (btnClickAnimation.running) {}
            else {actionButton.activated()}
        }
    }

 } // Rectangle
