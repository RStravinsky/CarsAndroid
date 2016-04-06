import QtQuick 2.5
import QtQuick.Controls 1.4

Item {
    property var fields
    function clearText() {
        for(var i=0;i<5;i++) {
            bookingFieldsRepeater.itemAt(i).customTextField.clear()
        }
        bookingFields.forceActiveFocus()
    }

    function dataIsEmpty() {
        if(bookingFieldsRepeater.itemAt(0).customTextField.text === "" ||
           bookingFieldsRepeater.itemAt(1).customTextField.text === "" ||
           bookingFieldsRepeater.itemAt(2).customTextField.text === "" ||
           bookingFieldsRepeater.itemAt(3).customTextField.text === "" ||
           bookingFieldsRepeater.itemAt(4).customTextField.text === ""  )
            return true
        return false
    }

    function getFields() {
        fields = [bookingFieldsRepeater.itemAt(0).customTextField.text,
                  bookingFieldsRepeater.itemAt(1).customTextField.text,
                  bookingFieldsRepeater.itemAt(2).customTextField.text,
                  bookingFieldsRepeater.itemAt(3).customTextField.text,
                  bookingFieldsRepeater.itemAt(4).customTextField.text,
                  ]
        return fields
    }

    Column {
        id: bookingFields
        anchors.fill: parent
        spacing: 6

        Repeater {
            id: bookingFieldsRepeater
            model: 5
            property variant pathList: ["/images/images/date_begin.png","/images/images/date_end.png","/images/images/name.png",
                                        "/images/images/surname.png","/images/images/destination.png"]
            property variant nameList: [qsTr("Data początkowa"),qsTr("Data końcowa"),qsTr("Imię"),qsTr("Nazwisko"),qsTr("Lokalizacja")]

            Row { id: row; spacing: 10; height: (bookingFields.height * .15); width: bookingFields.width - row.spacing;

                property alias customTextField: customTextField
                Rectangle { id: rect; height: row.height; width: row.height
                    Image { id: icon; anchors.fill: parent; anchors.margins: 7
                        source: bookingFieldsRepeater.pathList[index]
                        smooth: true
                        antialiasing: true
                    }
                }

                CustomTextField { id: customTextField; placeholderText: bookingFieldsRepeater.nameList[index]; height: row.height; width: row.width - rect.width;
                    Component.onCompleted: { if(index === 0 || index === 1) customTextField.activeButton = true }
                }

            } // Row

        } // Repeater

    } // Column

} // Item
