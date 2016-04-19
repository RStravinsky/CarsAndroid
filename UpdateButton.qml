import QtQuick 2.5

Item {
    id: updateButton
    property color hoverColor: "#FF6900"
    property color itemColor: "transparent"
    enabled: (informationScreen.text ===  "Łączenie ..." && informationScreen.visible === true )? false : true // disable when menu is open
    signal activated()
    property bool isActivated: false;  

    /* animation of main button*/
    RotationAnimation {
        id: updateButtonAnimation
        target: updateButton;
        from: 0
        to: 360
        duration: 200
        onRunningChanged: {
            if (updateButtonAnimation.running) {}
            else { updateButton.activated() }
        }
    }

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
            smooth: true
            antialiasing: true
            mipmap: true
        }

        MouseArea {
            id: mouseArea;
            visible: (informationScreen.text ===  "Łączenie ..." && informationScreen.visible === true ) ? false : true
            anchors.fill: rectangle
            hoverEnabled: true
            onEntered: rectangle.state = "ENTERED"
            onExited: rectangle.state = "EXITED"
            onClicked: {
                if(menuView.currentIndex === 0) { mainArea.menuChange() }
                informationScreen.text = "Łączenie ..."
                informationScreen.source = "images/images/wait.png"
                informationScreen.visible = true;
                updateButtonAnimation.running = true;
            }
        }

        states: [
            State {
                name: "ENTERED"
                PropertyChanges {
                    target: updateButton
                    itemColor: hoverColor
                }
            },
            State {
                name: "EXITED"
                PropertyChanges {
                    target: updateButton
                    itemColor: "transparent"
                }
            }
        ]

        transitions: [
            Transition {
                from: "EXITED"
                to: "ENTERED"
                ColorAnimation {
                    target: updateButton
                    duration: 10
                }
            },
            Transition {
                from: "ENTERED"
                to: "EXITED"
                ColorAnimation {
                    target: updateButton
                    duration: 10
                }
            }
        ]

     } // Rectangle

} // Item
