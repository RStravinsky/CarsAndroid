import QtQuick 2.5

Item {
    id: mainButton
    property color hoverColor: "#FF6900"
    property color itemColor: "transparent"
    property alias animation: mainButtonAnimation
    property int type: 0
    enabled: ((mainButton.rotation > 0 && mainButton.rotation < 180)) ? false : true
    signal buttonClicked()

    /* animation of main button*/
    SequentialAnimation {
        id: mainButtonAnimation
        RotationAnimation { target: mainButton;
            from: mainButton.type === 0 ? 0 : 180
            to: mainButton.type === 0 ? 180 : 0
            duration: 200
        }
        PropertyAction { target: mainButton; property: "type"; value: mainButton.type === 0 ? 1 : 0 }
    }

    Rectangle {
        id: rectangle
        anchors.fill: mainButton
        color: itemColor

        Image {
            id: buttonIcon
            width: rectangle.height * .4
            height: rectangle.width * .4
            anchors.centerIn: rectangle
            source: mainButton.type === 0 ? "/images/images/more.png" : "/images/images/return.png"
            smooth: true
            antialiasing: true
            mipmap: true
        }

        MouseArea {
            id: mouseArea;
            anchors.fill: rectangle
            visible: carViewClass.isBusy === true ? false : true
            hoverEnabled: true
            onEntered: rectangle.state = "ENTERED"
            onExited: rectangle.state = "EXITED"
            onClicked: { buttonClicked() }
        }

        states: [
            State {
                name: "ENTERED"
                PropertyChanges {
                    target: mainButton
                    itemColor: hoverColor
                }
            },
            State {
                name: "EXITED"
                PropertyChanges {
                    target: mainButton
                    itemColor: "transparent"
                }
            }
        ]

        transitions: [
            Transition {
                from: "EXITED"
                to: "ENTERED"
                ColorAnimation {
                    target: mainButton
                    duration: 10
                }
            },
            Transition {
                from: "ENTERED"
                to: "EXITED"
                ColorAnimation {
                    target: mainButton
                    duration: 10
                }
            }
        ]

     } // Rectangle

} // Item
