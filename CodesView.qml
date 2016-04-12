import QtQuick 2.5

Item {
    id: codesView
    anchors.fill: parent
    property var area: area

    SwipeArea {
        id: mouse
        menu: menuView
        anchors.fill: parent
        onMove: {
            console.log("onMove...")
            menuView.x = (-mainArea.width * menuView.currentIndex) + x // changing menu x
            normalViewMask.opacity = (1 -((Math.abs(menuView.x)/menuView.width)))/1.5 // changing normal view opacity
        }
        onSwipe: {
            console.log("onSwipe...")
            mainArea.menuChange()
        }
        onCanceled: {
            console.log("onCanceled...")
            menuView.currentIndexChanged()
            normalViewMask.opacity = menuView.currentIndex === 1 ? 0 : 0.7
        }
    }

    Rectangle {
        id: area
        property int offset: 20
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; top: parent.top; margins: offset }
        property int areaHeight: (screenH - topFrame.height - (2*offset))

        Component {
            id: carDelegate
            Item { id: carItem; height: area.areaHeight*.15; width: parent.width;

                Text { id: carName; height: parent.height * .2
                    anchors { left: parent.left; leftMargin: 5; top: parent.top;}
                    color: "gray"; font.pixelSize: screenH/30; text: brand + " " + model + " " + date + " " + time
                }

                Text { id: rentCode; height: parent.height * .6
                    anchors { left: parent.left; leftMargin: 5; bottom: parent.bottom; bottomMargin: 10 }
                    color: "#32b678"; font.pixelSize: screenH/20; text: code
                }

                ActionButton {
                    id: getCode; height: rentCode.height; width: getCode.height * 1.5
                    buttonText: qsTr("Skopiuj")
                    buttonColor: "#8c8c8c"
                    anchors { bottom: rentCode.bottom; right: parent.right }
                    enabled: menuView.currentIndex === 1 ? true : false
                    z: codesView.z + 1 // before parent
                    onActivated: { fileio.saveTo(code) }
                }

                Rectangle { height: 2; width: parent.width;
                    anchors { left: parent.left; horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
                    color: "lightgray";
                }

           } // Item

        } // Component

        ListView {
           id: carList
           anchors.fill: parent
           model: fileio.codeList
           delegate: carDelegate
           highlightMoveDuration: 0
        }
    }
} // Item