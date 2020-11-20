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
				todoText.visible = true;
			}
		}

	}

	Dialog {
		id: todoText
		visible: false;
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
					onClicked: { todoText.visible =  false } 

				}
			}

    		}
	}

} // end Item 
