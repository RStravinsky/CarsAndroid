import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.3

Item {  
    id: searchField

    Row { id: searchRow; anchors.fill: parent

        Rectangle { id: searchRect; height: searchRow.height; width: searchRow.height
            Image {
                id: searchIcon;
                width: searchRect.height * .5
                height: searchRect.width * .5
                anchors.centerIn: searchRect
                source: "/images/images/search.png"
                smooth: true
                antialiasing: true
            }
        }

        TextField { id: field; height: searchRect.height; width:  searchRow.width - searchRect.width;
            font.pointSize: 9 * point
            placeholderText: "wyszukiwanie samochodu"
            style: TextFieldStyle {
                    textColor: "gray"
                    placeholderTextColor: "lightgray"
                    background: Rectangle { border.width: 0 }
            }

            onTextChanged: {
               carView.list.positionViewAtIndex(carViewClass.findCarListIndex(field.text), ListView.Beginning)
            }

            Image {
                id: clearText
                anchors { top: parent.top; right: parent.right; rightMargin: 5; verticalCenter: parent.verticalCenter }
                height: field.font.pointSize * 1.3
                width: field.font.pointSize * 1.3
                fillMode: Image.PreserveAspectFit
                smooth: true; visible: (field.text && field.focus === true)
                source: "/images/images/clear.png"

                MouseArea {
                    id: clear
                    anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
                    height: field.height; width: field.height
                    //visible: informationScreen.visible === true ? false : true
                    onClicked: {
                        field.text = ""
                        field.forceActiveFocus()
                    }
                }
            }

        } // TextField

    } // Row

} // Item
