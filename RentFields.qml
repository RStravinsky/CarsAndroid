import QtQuick 2.5

Item {
    property var fields
    function clearText() {
        for(var i=0;i<4;i++) {
            rowsModel.itemAt(i).customTextField.clear()
        }
        rentFields.forceActiveFocus()
    }

    function setPersonalData(name, surname) {
        rowsModel.itemAt(0).customTextField.text = name
        rowsModel.itemAt(1).customTextField.text = surname
    }

    function dataIsEmpty() {
        if(rowsModel.itemAt(0).customTextField.text === "" ||
           rowsModel.itemAt(1).customTextField.text === "" ||
           rowsModel.itemAt(2).customTextField.text === "" ||
           rowsModel.itemAt(3).customTextField.text === "")
            return true
        return false
    }

    function getFields() {
        fields = [rowsModel.itemAt(0).customTextField.text,
                  rowsModel.itemAt(1).customTextField.text,
                  rowsModel.itemAt(2).customTextField.text,
                  rowsModel.itemAt(3).customTextField.text]
        return fields
    }

    Column {
        id: rentFields
        anchors.fill: parent
        spacing: 6

        Repeater {
            id: rowsModel
            model: 4
            property variant pathList: ["/images/images/name.png","/images/images/surname.png","/images/images/destination.png","/images/images/target.png"]
            property variant nameList: [qsTr("Imię"),qsTr("Nazwisko"),qsTr("Lokalizacja"),qsTr("Cel wizyty")]

            Row { id: row; spacing: 10; height: (rentFields.height * .25); width: rentFields.width - row.spacing;

                property alias customTextField: customTextField
                Rectangle { id: rect; height: row.height; width: row.height
                    Image { id: icon; anchors.fill: parent; anchors.margins: 7
                        source: rowsModel.pathList[index]
                        smooth: true
                        antialiasing: true
                        mipmap: true
                    }
                }

                CustomTextField { id: customTextField; placeholderText: rowsModel.nameList[index]; height: row.height; width: row.width - rect.width;
                    Component.onCompleted: {
                        if(index === 0) { customTextField.validator = regExpValidator }
                        if(index === 1) { customTextField.validator = regExpValidator }
                    }
                }

            } // Row

        } // Repeater

    } // Column

} // Item
