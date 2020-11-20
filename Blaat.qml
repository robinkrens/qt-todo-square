import QtQuick 2.0
import QtQuick.Controls 2.0

Item {
    id: container
    property alias cellColor: rectangle.color
    signal clicked(color cellColor)

    width: 20; height: 12; y: 100;

    Rectangle {
        id: rectangle
        border.color: "black"
        anchors.fill: parent
	}

    MouseArea {
        anchors.fill: parent
        onClicked: container.clicked(container.cellColor)
    }
}
