import QtQuick 2.5
import QtQuick.Controls 1.4

Item {
    property var fields
    property alias bookingFieldsRepeater: bookingFieldsRepeater
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
                        mipmap: true
                    }
                }

                CustomTextField { id: customTextField; placeholderText: bookingFieldsRepeater.nameList[index]; height: row.height; width: row.width - rect.width; property string choosenTime; property string startDateTimeText;
                    Component.onCompleted: { if(index === 0 || index === 1) customTextField.activeButton = true; dateTimeType = index; }
                    onTextChanged: {
                        if(index === 0 || index === 1) {

                            if(bookingFieldsRepeater.itemAt(index).customTextField.text !== "") {
                                choosenTime = bookingFieldsRepeater.itemAt(index).customTextField.text
                                choosenTime = choosenTime.split(" ")[1]
                                choosenTime = choosenTime.split(":")[0] + ":00"
                            }

                            if(carViewClass.carList[listIndex].setHoursColor(Date.fromLocaleString(Qt.locale(), bookingFieldsRepeater.itemAt(index).customTextField.text, "yyyy-MM-dd hh:mm"), choosenTime) === 1 ) {
                                warningVisible = true
                            }
                            else {
                                warningVisible = false
                            }
                        }
                    }
                    onMouseAreaClicked: {
                        dateChooser.clearDateTimeStrings()
                        if((field.text !== "")) {
                            console.log(field.text)
                            dateChooser.setDateChooser(field.text.split(" ")[0], field.text.split(" ")[1])
                        }
                    }
                }

            } // Row

        } // Repeater

    } // Column

} // Item
