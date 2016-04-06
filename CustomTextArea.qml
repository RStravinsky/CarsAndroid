import QtQuick 2.5
import QtQuick.Controls 1.4

Item {
    id: customTextArea
    property string placeholderText: ""
    property alias text: textEdit.text
    function clear() { textEdit.text = "" }

    Rectangle {
        id: notes;
        anchors.fill:parent
        border.width: 3
        border.color: textEdit.focus === true ? "#69C0D9" : "lightgray"

        Text { id: placeHolder; width: parent.width - (2 * font.pointSize); height: 2 * font.pointSize
            anchors{ top: parent.top; left:parent.left; leftMargin: 10; topMargin: 10 }
            horizontalAlignment: Text.AlignLeft
            clip: true
            color: "lightgray"
            text: textEdit.text === "" ? placeholderText : ""
            font.pixelSize: screenH/30
        }

        Flickable {
             id: flick
             anchors { fill:parent; margins: 10 }
             contentWidth: textEdit.paintedWidth
             contentHeight: textEdit.paintedHeight
             clip: true
             flickableDirection: Flickable.VerticalFlick

             function ensureVisible(r) {
                 if (contentY >= r.y) { contentY = r.y }
                 else if (contentY+height <= r.y+r.height) { contentY = r.y+r.height-height }
             }

             TextEdit { id: textEdit; width: flick.width; height: flick.height
                 wrapMode: TextEdit.Wrap
                 font.pixelSize: screenH/30
                 color: "gray"
                 onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
             }

         } // Flickable

    } // Rectangle

} // Item
