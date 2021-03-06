import QtQuick 2.5

Item {
    property alias text: initText.text
    property alias source: waitImage.source
    signal activated()

    Rectangle {
        anchors.fill: parent

        Image {
            id: waitImage
            height: parent.height/5
            width: parent.height/5
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            source: "images/images/wait.png"
            smooth: true
            antialiasing: true
            mipmap: true

            MouseArea {
                anchors.fill: parent
                propagateComposedEvents: true
                onClicked: { activated() }
            }
        }

        Text {
            id: initText
            width: parent.width
            height: font.pointSize * 2
            anchors.top: waitImage.bottom
            font.pointSize: 12 * point
            horizontalAlignment: Text.AlignHCenter
            text: "Łączenie ..."
            color: "gray"
        }

    } // Rectangle

} // Item
