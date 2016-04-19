import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.3

Item {
    property int previousMileage: carViewClass.carList[listIndex].mileage;
    property var fields

    function clearText() { mileage.clear(); notes.clear(); returnFields.forceActiveFocus() }

    function dataIsEmpty() {
        if(mileage.text === "")
            return true
        return false
    }

    function getFields() {
        fields = [mileage.text,notes.text]
        return fields
    }

    function getDistance() {
        if((mileage.text*1) <= previousMileage)
            return -1
        else return (mileage.text*1)- previousMileage
    }

    Column {
        id: returnFields
        anchors.fill: parent
        spacing: 15

        Row { id: mileageRow;  spacing: 10; height: (returnFields.height * .15); width: returnFields.width - mileageRow.spacing;

            Rectangle { id: mileageRect; height: mileageRow.height; width: mileageRow.height
                Image { id: mileageIcon; anchors.fill: parent; anchors.margins: 7
                    source: "/images/images/speed.png"
                    smooth: true
                    antialiasing: true
                }
            }

            CustomTextField { id: mileage; placeholderText: qsTr("Przebieg"); height: mileageRow.height; width: mileageRow.width - mileageRect.width;
                maximumLength: 11
                validator: IntValidator { bottom: 0; top: 2147483647 }
                inputMethodHints: Qt.ImhDigitsOnly
            }
        }


        Row { id: notesRow; spacing: 10; height: (returnFields.height * .15) * 4; width: returnFields.width - notesRow.spacing

            Rectangle { id: notesRect; height: mileageRect.height; width: mileageRect.height
                Image { id: notesIcon; anchors.fill: parent; anchors.margins: 7
                    source: "/images/images/notes.png"
                    smooth: true
                    antialiasing: true
                    mipmap: true
                }
            }

            CustomTextArea  { id: notes; height: (returnFields.height * .15) * 4; width: notesRow.width - notesRect.width; placeholderText: qsTr("Uwagi - nie obowiązkowe"); }
        }

    } // Column

} // Item


