import QtQuick 2.5

Item {
    id: updateButton
    property color hoverColor: "lightgray"
    property color itemColor: "transparent"
    enabled: ((menuView.currentIndex === 1) || (loadingScreen.visible === false)) ? true : false // disable when menu is open
    signal activated()
    property bool isActivated: false;

    Rectangle {
        id: rectangle
        anchors.fill: updateButton
        color: itemColor

        Image {
            id: buttonIcon
            width: rectangle.height * .4
            height: rectangle.width * .4
            anchors.centerIn: rectangle
            source: "/images/images/update.png"
        }

        MouseArea {
            id: mouseArea;
            anchors.fill: rectangle
            onClicked: {
                btnClickAnimation.running = true;
            }
        }

        SequentialAnimation {
            id: btnClickAnimation
            PropertyAnimation { target: updateButton; property: "opacity"; easing.type: Easing.Linear; to: 0; duration: 30 }
            PropertyAnimation { target: updateButton; property: "opacity"; easing.type: Easing.Linear; to: 1; duration: 30 }
            onRunningChanged: {
                if (btnClickAnimation.running) {}
                else { loadingScreen.visible = true; updateButton.activated() }
            }
        }

     } // Rectangle

} // Item
