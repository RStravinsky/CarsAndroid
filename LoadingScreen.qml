import QtQuick 2.5

Item {

    Rectangle {
        id: loadingRect
        anchors.fill: parent

        Image {
            id: waitImage
            height: parent.height/5
            width: parent.height/5
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            source: "images/images/wait.png"
        }

        Text {
            id: initText
            width: parent.width
            height: font.pointSize * 2
            anchors.top: waitImage.bottom
            font.pointSize: screenH/40
            horizontalAlignment: Text.AlignHCenter
            text: "Łączenie ..."
            color: "gray"
        }

    } // Rectangle

} // Item
