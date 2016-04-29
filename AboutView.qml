import QtQuick 2.5
import QtQuick.Controls 1.4

Item {
    id:aboutView
    anchors.fill: parent
    property alias area: area

    SwipeArea {
        id: mouse
        menu: menuView
        anchors.fill: parent
        onMove: {
            //console.log("onMove...")
            area.enabled = false
            menuView.x = (-mainArea.width * menuView.currentIndex) + x // changing menu x
            normalViewMask.opacity = (1 -((Math.abs(menuView.x)/menuView.width)))/1.5 // changing normal view opacity
        }
        onSwipe: {
            //console.log("onSwipe...")
            mainArea.menuChange()
        }
        onCanceled: {
            //console.log("onCanceled...")
            menuView.currentIndexChanged()
            normalViewMask.opacity = menuView.currentIndex === 1 ? 0 : 0.7
            area.enabled = menuView.currentIndex === 1 ? true : false
        }
    }

    Rectangle {
        id: area
        property int offset: 20
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; top: parent.top; margins: offset }
        property int areaHeight: (screenH - topFrame.height - (2*offset))

        Image {
            id: logo
            height: area.areaHeight * 0.2
            anchors { left: parent.left; leftMargin: width/4; top: parent.top; topMargin: 5; }
            fillMode: Image.PreserveAspectFit
            cache: true
            mipmap: true
            smooth: true
            antialiasing: true
            source: "/images/images/logo.png"
        }

        Label {
            id: titleLabel
            textFormat: Text.RichText
            text: "Rezerwacja v.1.0"
            anchors { left: logo.right; leftMargin: logo.width/4; top: logo.verticalCenter }
            font.pointSize: 9 * point
            color: "gray"
        }

        Label {
            id: companyLabel
            textFormat: Text.RichText
            text: "All rights reserved \u00A9 SIGMA S.A."
            anchors { left: logo.right; leftMargin: logo.width/4; top: titleLabel.bottom; topMargin: 2*point }
            font.pointSize: 5 * point
            color: "gray"
        }

        Text {
            id: contentText
            textFormat: Text.RichText
            text: "Masz jakiś problem, uwagi, sugestie? <br>Wyślij wiadomość na adres: <a href=\"mailto:michal.stojek@sigmasa.pl\">EMAIL</a>"
            anchors { left: logo.left; top: logo.bottom; right: parent.right; rightMargin: logo.width/4; topMargin: logo.height/4; }
            font.pointSize: 7 * point
            color: "gray"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft
            onLinkActivated: { Qt.openUrlExternally("mailto:software@sigmasa.pl?subject=&body=") }
        }

        //    Text {
        //        id: contentText
        //        textFormat: Text.RichText
        //        text: "Mechanika, elektronika, automatyka, programowanie, chemia z Niemiec. <br><br>Masz problem? Napisz:   <a href=\"mailto:michal.stojek@sigmasa.pl\">Michał Stojek</a>"
        //        anchors { left: logo.left; top: logo.bottom; right: parent.right; rightMargin: logo.width/4; topMargin: logo.height/4; }
        //        font.pointSize: 7 * point
        //        color: "gray"
        //        wrapMode: Text.WordWrap
        //        horizontalAlignment: Text.AlignLeft
        //        onLinkActivated: { Qt.openUrlExternally("mailto:michal.stojek@sigmasa.pl?subject=Zamówienie na chemię&body=Poproszę o proszek z Dusseldorfu.") }
        //    }

    } // Rectangle

} // Item
