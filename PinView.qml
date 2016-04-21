import QtQuick 2.5
import QtQuick.Dialogs 1.2

Item {
    anchors.fill: parent
    property string returnCode
    property alias field: code.field
    property int listIndex
    function clearText() { code.clear(); label.forceActiveFocus() }
    function setListIndex(val) { listIndex = val }

    Rectangle {
        id: area
        property int offset: 20
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; top: parent.top; margins: offset }
        property int areaHeight: (screenH - topFrame.height - (2*offset))
        enabled: (loadingRect.isLoading === true) ? false : true

        Text { id: label; width: parent.width; height: label.font.pointSize * 2
            anchors { top: parent.top; topMargin: 20; }
            horizontalAlignment: Text.AlignHCenter
            text: "Wprowadź kod:"
            font.pointSize: 8 * point
            color: "gray"
        }

        CustomTextField { id: code;  width: parent.width/2; height: 50;
            anchors { horizontalCenter: parent.horizontalCenter; top: label.bottom; topMargin: 30; }
            horizontalAlignment: Text.AlignHCenter
            maximumLength : 6
            customReturnKey: true
            validator: IntValidator { bottom: 0; top: 999999 }
            inputMethodHints: Qt.ImhDigitsOnly
        }

        ActionButton {
            id: getCode; height: code.height; width: code.width
            buttonText: qsTr("Wklej ze schowka")
            buttonColor: "#8c8c8c"
            anchors { top: code.bottom; topMargin: 10; horizontalCenter: parent.horizontalCenter }
            onActivated: { code.field.text = ""; code.field.paste() }
        }

        // rent/return button
        ActionButton { id: leaveBtn; width: parent.width; height: area.areaHeight * .13;
            property var fields;
            anchors { bottom: parent.bottom; left: parent.left; right: parent.right; }
            buttonColor: "#db4437"
            buttonText: qsTr("Oddaj")
            fontSize: 16 * point

            onActivated: {
                loadingRect.isLoading = true // enable loaidng
                if(carViewClass.carList[pinView.listIndex].isCodeCorrect(carViewClass.carList[pinView.listIndex].id,field.text)) {
                    if(carViewClass.carList[listIndex].updateHistory(rentView.returnFields.getFields(),rentView.distance))
                    {
                        fileio.removeCode(field.text)
                        Qt.inputMethod.hide() // hide virtual keyboard
                        messageDialog.show("Oddano!", "Samochód został oddany.", StandardIcon.Information, true); // RELOAD APP
                    }
                    else { loadingRect.isLoading = false; messageDialog.show("Uwaga!", "Polecenie nie powiodło się.", StandardIcon.Warning, false); }
                }
                else { loadingRect.isLoading = false; messageDialog.show("Niepoprawny kod!", "Spróbuj ponownie.", StandardIcon.Warning, false); }

            } // OnActivated

        } // ActiveButton

    } // Rectangle

} // Item
