import QtQuick 2.5

Item {
    id: menuView
    width: mainArea.width * .9; height: mainArea.height
    x: -mainArea.width

    property var mainArea
    property int currentIndex: 1
    signal itemClicked(int idx)
    property color menuColor: "#303030"
    property color itemHighlightColor: "gray"
    property var list: menuList
    property int previousIndex: 0
    property int mouseOrigin: 0

    onCurrentIndexChanged: {
        slide_anim.to = - mainArea.width * currentIndex
        slide_anim.start()
    }

    PropertyAnimation {
        id: slide_anim
        target: menuView
        easing.type: Easing.OutExpo
        duration: 150
        properties: "x"
    }

    // menu list
    Rectangle {
        anchors.fill:parent
        color: menuColor;

        ListModel {id: menuModel
            ListElement { name: "Lista samochodów";imagePath: "/images/images/reserve.png"}
            ListElement { name: "Ustawienia"; imagePath:"/images/images/settings.png"}
            ListElement { name: "Moje kody"; imagePath:"/images/images/code.png"}
            ListElement { name: "O aplikacji"; imagePath:"/images/images/appinfo.png"}
        }

        Component {
            id: menuDelegate
            Item { id:menuItem; height: screenH * .1; width: parent.width;
                Image { height: 25; width: 25
                    anchors { left: parent.left; leftMargin: 5; verticalCenter: parent.verticalCenter }
                    source: imagePath
                    smooth: true
                    antialiasing: true
                    mipmap: true
                }
                Text { id: menuText;
                    anchors { left: parent.left; leftMargin: 40; verticalCenter: parent.verticalCenter }
                    color: "white"; font.pointSize: 10 * point
                    text: name
                }
                Rectangle { height: 2; width: parent.width * 0.70;
                    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                    color: "gray";
                }
                MouseArea { id: mouseArea; anchors.fill: menuItem; hoverEnabled: true;
                    onPressed: {
                        menuList.currentIndex = index
                        mouseOrigin = mouseY;
                    }
                    onReleased: {
                        if(menuList.currentIndex === -1) { menuList.currentIndex = menuView.previousIndex }
                        else { itemClicked(index); previousIndex = index }
                    }
                    onPositionChanged: {
                        if(Math.abs(mouseY - mouseOrigin) > menuItem.height && mouseY < 1000) {
                            menuList.currentIndex = -1
                        }
                    }

                } 

           } // Item
        } // Component

        ListView {
           id: menuList
           anchors.fill: parent
           model: menuModel
           delegate: menuDelegate
           highlightMoveDuration: 0
           interactive: false
           highlight: Rectangle {
               color: itemHighlightColor;
               visible: currentIndex === 1 ? 0 : 1
           }
           currentIndex: 0
        }

    } // Rectangle

} // Item
