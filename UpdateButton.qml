import QtQuick 2.5

Item {
    id: updateButton
    property color hoverColor: "#FF6900"
    property color itemColor: "transparent"
    enabled: loadingScreen.visible === true ? false : true // disable when menu is open
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
            hoverEnabled: true
            onEntered: rectangle.state = "ENTERED"
            onExited: rectangle.state = "EXITED"
            onClicked: {
                loadingScreen.visible = true;
                loadingScreen.text = "Łączenie ..."
                loadingScreen.source = "images/images/wait.png"
                updateButton.activated()
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
