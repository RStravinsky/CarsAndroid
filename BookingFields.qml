import QtQuick 2.5
import QtQuick.Controls 1.4

Item {
    property var fields
    function clearText() {
        for(var i=0;i<3;i++) {
            rowsModel.itemAt(i).customTextField.clear()
        }
        bookingFields.forceActiveFocus()
    }

    function dataIsEmpty() {
        if(rowsModel.itemAt(0).customTextField.text === "" ||
           rowsModel.itemAt(1).customTextField.text === "" ||
           rowsModel.itemAt(2).customTextField.text === "")
            return true
        return false
    }

    function getFields() {
        fields = [rowsModel.itemAt(0).customTextField.text,
                  rowsModel.itemAt(1).customTextField.text,
                  rowsModel.itemAt(2).customTextField.text,
                  ]
        return fields
    }

    Column {
        id: bookingFields
        anchors.fill: parent
        spacing: 6

        Repeater {
            id: rowsModel
            model: 5
            property variant pathList: ["/images/images/name.png","/images/images/surname.png","/images/images/destination.png"]
            property variant nameList: [qsTr("Imię"),qsTr("Nazwisko"),qsTr("Lokalizacja")]

            Row { id: row; spacing: 10; height: (bookingFields.height * .15); width: bookingFields.width - row.spacing;

                property alias customTextField: customTextField
                Rectangle { id: rect; height: row.height; width: row.height
                    Image { id: icon; anchors.fill: parent; anchors.margins: 7
                        source: rowsModel.pathList[index]
                        smooth: true
                        antialiasing: true
                    }
                }

                CustomTextField { id: customTextField; placeholderText: rowsModel.nameList[index]; height: row.height; width: row.width - rect.width; }

            } // Row

        } // Repeater

    } // Column

} // Item
