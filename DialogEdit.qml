import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2

Item {
	id: container;
	property bool visibility: false;
	Dialog {
		id: todoText
		visible: visibility;
		title: "enter todo"
		contentItem: Rectangle {
		        implicitWidth: 250
		        implicitHeight: 50
			Grid {
				columns: 2;
				anchors.fill: parent
				TextField {
					width: 150;
					//color: "navy"
	    			}
				Button {
					text: "OK!";
					width: 30;
					onClicked: { visibility =  false } 
				}
			}
		}
	}
}

