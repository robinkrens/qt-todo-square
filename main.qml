import QtQuick 2.0
import QtQml.Models 2.1
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2

Item {
	property int customHeight: 250;
	property int customWidth: 400;
	property string introText: "left-click: view | right-click: add | shift-click: delete";
	property int currentItem: -1;

	id: root
	width: customWidth; height: customHeight;
	focus: true;

	Keys.onPressed: {
		if (event.key == Qt.Key_Delete) {
			if (root.currentItem >= 0) {
				console.log(todoList.get(root.currentItem).name);
				todoList.remove(root.currentItem, 1);
				root.currentItem = -1;
				showCurrent.text = root.introText;
			}	
		}
	}

	Rectangle {
		id: page
		//property int currentItem: -1;
		anchors.fill: parent;
		//width: 400; height: 300
		color: "lightgray"

		Rectangle {
			width: 30;
			height: 30;
			anchors.left: page.right;
			anchors.leftMargin: -30;

			Image {
			       anchors.fill: parent
			       source: "trash.png"
		       }
	       }

		ListModel {
			id: todoList;
		        ListElement {
				name: "example todo";
				xpos: 100; ypos: 100;
				bgcolor: "black";
	        	}
		}

		ListView {
			id: view;
			model: todoList;
		}

		Repeater {
			//width: 400; height: parent.height;
			model: todoList;
			delegate: todoDelegate;
		}	

		MouseArea {
			anchors.fill: parent;
			acceptedButtons: Qt.RightButton /* | Qt.LeftButton */;
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
			property bool holding: false;
			id: wrapper
			width: 12; height: 12;
			color: index == root.currentItem ? "red" : bgcolor;
			radius: 8;
			antialiasing: true;
			x: xpos; y: ypos;
			//onDragStarted: {
			//	console.log("on press and hold event");
			//	showCurrent.text = todoList.get(index).name;
			//	page.currentItem = index;
			//}
			MouseArea {
				anchors.fill: parent;
				//onClicked: console.log(todoList.setProperty(index, "xpos", 50));
				onClicked: {
					console.log(todoList.get(index).name);
					showCurrent.text = todoList.get(index).name;
					root.currentItem = index;
					if (mouse.modifiers & Qt.ShiftModifier) {
						console.log("shift!");
					}
				//	todoList.setProperty(index, "bgcolor", "blue");
				}
				onPressAndHold: {
					console.log("on press and hold event");
					showCurrent.text = todoList.get(index).name;
					root.currentItem = index;
				}
				onReleased: {
					//console.log("xpos: " + todoList.get(index).xpos + mouseX);
					console.log("mouseX: " + wrapper.x);
					if (wrapper.x > (customWidth - 35) && wrapper.y < 30) {
						console.log("deleting...");
						todoList.remove(root.currentItem, 1);
						root.currentItem = -1;
						showCurrent.text = root.introText;
							
					}
					todoList.get(index).xpos = wrapper.x;
					todoList.get(index).ypos = wrapper.y;
				}
				drag.target: wrapper;
				drag.axis: Drag.XAndYAxis;

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
			"bgcolor" : "black" });
		}
	}

	function doSomething() 
	{ console.log("lolz"); }
} 
