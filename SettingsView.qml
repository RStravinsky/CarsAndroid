import QtQuick 2.5

Item {
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        Text { id: menuText;
            anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
            color: "orange"; font.pixelSize: 32; text: "SETTINGS ..."
        }

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
    } // test area



}
