import QtQuick 2.5

Item {
    id: settings
    property var fields

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
        id: settingsFields
        anchors.fill: parent
        spacing: 6

        Repeater {
            id: rowsModel
            model: 4
            property variant pathList: ["/images/images/ip.png","/images/images/port.png","/images/images/name.png","/images/images/password.png"]
            property variant nameList: [qsTr("Adres"),qsTr("Port"),qsTr("Użytkownik"),qsTr("Hasło")]

            Row { id: row; spacing: 10; height: (settingsFields.height * .15); width: settingsFields.width - row.spacing;

                property alias customTextField: customTextField
                Rectangle { id: rect; height: row.height; width: row.height
                    Image { id: icon; anchors.fill: parent; anchors.margins: 7
                        source: rowsModel.pathList[index]
                        smooth: true
                        antialiasing: true
                        mipmap: true
                    }
                }

                CustomTextField { id: customTextField; text: sqlDatabase.settingsParameter[index]; placeholderText: rowsModel.nameList[index]; height: row.height; width: row.width - rect.width;
                                  displayTextWay: index === 3 ? TextInput.Password : TextInput.Normal; inputMethodHints: index === 3 ? Qt.ImhHiddenText : Qt.ImhNone
                    Component.onCompleted: {
                        if(index === 0) { customTextField.validator = hostRegExpValidator; customTextField.inputMethodHints = Qt.ImhFormattedNumbersOnly; }
                        if(index === 1) { customTextField.validator = intValidaotr; customTextField.inputMethodHints = Qt.ImhDigitsOnly }
                    }
                }

            } // Row

        } // Repeater

    } // Column

} // Item
