import QtQuick 2.0
import QtQml.Models 2.1
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2

Item {
	id: root
	width: 400; height: 300

	Rectangle {
		id: page
		width: 400; height: 300
		color: "lightgray"

		ListModel {
	    		id: myModel;
		        ListElement {
		        	cellColor: "lolz";
	        	}
		}

		ListView {
			width: 400; height: parent.height;
			model: myModel
			delegate: Text { text: cellColor } 
			//delegate: Cell { cellColor: "red"; }
			//delegate: Item { id: name; Rectangle { x: posx; y: posy; width: 10; height: 10; color: bgcolor; 
			//	MouseArea { xnchors.fill: parent; onClicked: { parent.color = 'red' }} } }
		}	

		MouseArea {
			anchors.fill: parent;
			acceptedButtons: Qt.RightButton;
			onClicked: {
			    	console.log("x:" + mouseX, " y:" + mouseY);
				myModel.append({"cellColor" : "lolzz" });
				todoText.visibility = true;
			}
		}

	}
	DialogEdit {
		id: todoText;
	}

} // end Item 
