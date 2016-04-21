import QtQuick 2.5

Item {
    id: settings
    property var fields

    function dataIsEmpty() {
        if(rowsModel.itemAt(0).customTextField.text === "" ||
           rowsModel.itemAt(1).customTextField.text === "")
            return true
        return false
    }

    function getFields() {
        fields = [rowsModel.itemAt(0).customTextField.text,
                  rowsModel.itemAt(1).customTextField.text]
        return fields
    }

    Column {
        id: userFields
        anchors.fill: parent
        spacing: 6

        Repeater {
            id: rowsModel
            model: 2
            property variant pathList: ["/images/images/name.png","/images/images/surname.png"]
            property variant nameList: [qsTr("Imię"),qsTr("Nazwisko")]

            Row { id: row; spacing: 10; height: (userFields.height * .25); width: userFields.width - row.spacing;

                property alias customTextField: customTextField
                Rectangle { id: rect; height: row.height; width: row.height
                    Image { id: icon; anchors.fill: parent; anchors.margins: 7
                        source: rowsModel.pathList[index]
                        smooth: true
                        antialiasing: true
                        mipmap: true
                    }
                }

                CustomTextField { id: customTextField; text: sqlDatabase.settingsParameter[index+4]; placeholderText: rowsModel.nameList[index]; height: row.height; width: row.width - rect.width; }

            } // Row

        } // Repeater

    } // Column

} // Item
