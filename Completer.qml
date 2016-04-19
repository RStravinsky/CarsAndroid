import QtQuick 2.5
import QtQuick.Controls 1.4

Item {
    id: completer

    anchors.top: parent.bottom
    anchors.left: parent.left

    width: parent.width // + border.width
    height: itemHeight * model.count // + 2 * listView.anchors.margins + border.width

    property alias model: listView.model
    property int itemHeight: 55

    signal textSelected(string text)

   z: topFrame.z + 1

    Rectangle {
        id: rect
        width:parent.width
        height: parent.height
        color: "#F9F9F9"
        border.color: "#CACACA"
        z: parent.z + 1

        ListView {
            id: listView
            anchors.fill: parent
            anchors.margins: 3
            clip: true

            delegate: Rectangle {
                width: parent.width
                height: itemHeight
                z: parent.z + 1

                property color defaultColor: "#F9F9F9"
                property color highlightColor: "red"
                color: defaultColor

                Label {
                    id: suggestionText

                    anchors.fill: parent
                    anchors.leftMargin: 15

                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    text: name
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: parent.color = parent.highlightColor
                    onReleased: parent.color = parent.defaultColor
                    onCanceled: parent.color = parent.defaultColor

                    onClicked: {
                        completer.textSelected(suggestionText.text);
                    }
                }
            }
        }
    } // Rectangle

} // Item
