import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2

Item {
	id: container;
	property bool visibility: false;
	property int clickedX: 0;
	property int clickedY: 0;
	property alias emptyText: todoDescr.text;
	signal added(string todo);
	Dialog {
		id: todoText
		visible: visibility;
		title: "Enter todo:"
		contentItem: Rectangle {
		        implicitWidth: 250
		        implicitHeight: 50
			Grid {
				columns: 2;
				anchors.fill: parent
				TextField {
					id: todoDescr;
					width: 150;
					//color: "navy"
	    			}
				Button {
					text: "OK!";
					width: 30;
					onClicked: { visibility =  false;
					if (todoDescr.text != "")
						container.added(todoDescr.text); }
				}
			}
		}
	}
}

