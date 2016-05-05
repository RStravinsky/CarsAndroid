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
            area.enabled = false
            menuView.x = (-mainArea.width * menuView.currentIndex) + x // changing menu x
            normalViewMask.opacity = (1 -((Math.abs(menuView.x)/menuView.width)))/1.5 // changing normal view opacity
        }
        onSwipe: {
            mainArea.menuChange()
        }
        onCanceled: {
            menuView.currentIndexChanged()
            normalViewMask.opacity = menuView.currentIndex === 1 ? 0 : 0.7
            area.enabled = menuView.currentIndex === 1 ? true : false
        }
    }

    Rectangle {
        id: area
        property int offset: 20
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; top: parent.top; margins: offset }
        property int areaHeight: (screenH - topFrame.height - (2*offset))

        // reload screen
        InformationScreen {
            id: informationScreen
            anchors.fill: parent
            visible: carList.count > 0 ? false : true
            text: "Brak kodów"
            source: "/images/images/list.png"
        }

        Component {
            id: carDelegate
            Item { id: carItem; height: area.areaHeight*.15; width: parent.width;

                Text { id: carName; height: parent.height * .2
                    anchors { left: parent.left; leftMargin: 5; top: parent.top;}
                    color: "gray"; font.pointSize: 9 * point //(screenH/(30*ratio));
                    text: brand + " " + model + " " + date + " " + time
                }

                Text { id: rentCode; height: parent.height * .6
                    anchors { left: parent.left; leftMargin: 5; bottom: parent.bottom; bottomMargin: 10 }
                    color: isRent === true ? "#db4437" : "#FF8C00"; font.pointSize: 17 * point //(screenH/(20*ratio));
                    text: code
                }

                ActionButton {
                    id: getCode; height: rentCode.height; width: getCode.height * 1.5
                    buttonText: qsTr("Skopiuj")
                    buttonColor: "lightgray"
                    anchors { bottom: rentCode.bottom; right: parent.right }
                    onActivated: { fileio.saveToClipboard(code) }
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
