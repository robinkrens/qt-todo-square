import QtQuick 2.0
import QtQml.Models 2.1
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2

Item {
	id: root
	width: 400; height: 300


	Rectangle {
		id: page
		property int currentItem: -1;
		width: 400; height: 300
		color: "lightgray"

		ListModel {
			id: todoList;
		        ListElement {
				name: "example todo";
				xpos: 100; ypos: 100;
				bgcolor: "red";
	        	}
		}

		ListView {
			id: view;
			model: todoList;
		}

		Repeater {
			width: 400; height: parent.height;
			model: todoList;
			delegate: todoDelegate;
		}	

		MouseArea {
			anchors.fill: parent;
			acceptedButtons: Qt.RightButton /*  | Qt.LeftButton */;
			onClicked: {
				if (mouse.button == Qt.RightButton) {
				    	console.log("x:" + mouseX, " y:" + mouseY);
					todoText.visibility = true;
					todoText.clickedX = mouseX;
					todoText.clickedY = mouseY;
					todoText.emptyText = "";
				}
				//else if (mouse.button == Qt.LeftButton) {
				//	console.log("view");
				//}
			}
		}
		Text {
			id: showCurrent;
			anchors.fill: parent;
			text: "left-click: view | right-click: add | shift-click: delete";
			verticalAlignment: Text.AlignBottom;
		}
		//Button {
		//}

	}

	Component {
		id: todoDelegate
		Rectangle { 
			id: wrapper
			width: 12; height: 12;
			color: index == page.currentItem ? "red" : "black";
			radius: 8;
			antialiasing: true;
			x: xpos; y: ypos;
			MouseArea {
				anchors.fill: parent;
				//onClicked: console.log(todoList.setProperty(index, "xpos", 50));
				onClicked: {
					console.log(todoList.get(index).name);
					showCurrent.text = todoList.get(index).name;
					page.currentItem = index;
				//	todoList.setProperty(index, "bgcolor", "blue");
				}
			}
		//	Tooltip { 
		//		visible: down;
		//		text: "blaat";
		//	}
		}
	}

	DialogEdit {
		id: todoText;
		onAdded: function(todo) {
			console.log("Recv: " + todo);
			todoList.append({"name" : todo, 
			"xpos" : todoText.clickedX, "ypos" : todoText.clickedY, 
			"bgcolor" : "red" });
		}
	}

	function doSomething() 
	{ console.log("lolz"); }
} 
