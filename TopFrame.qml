import QtQuick 2.5

Item
{
    id: topFrame
    Rectangle {
        id: rectangle
        anchors.fill: topFrame
        gradient: Gradient {
            GradientStop { position: 0; color: "#FF8C00" }
            GradientStop { position: 1; color: "#FF6900" }
            }

    } // Rectangle

} // Item
