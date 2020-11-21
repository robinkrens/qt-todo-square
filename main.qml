import QtQuick 2.0
import QtQml.Models 2.1
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import "./todo.js" as Todo

Item {
	property int customHeight: 250;
	property int customWidth: 400;

	id: root
	width: customWidth; height: customHeight;
	focus: true;

	Keys.onPressed: {
		if (event.key == Qt.Key_Delete) {
			Todo.deleteItem(todoList, page);
		}
	}

	Rectangle {
		
		id: page
		anchors.fill: parent;
		
		property int currentItem: -1;
		property string introText: "left-click: view | right-click: add | shift-click: delete";
		property alias introText: showCurrent.text;
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

		Repeater {
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

	}

	Component {
		id: todoDelegate
		Rectangle { 
			property bool holding: false;
			id: wrapper
			width: 12; height: 12;
			color: index == page.currentItem ? "red" : "black";
			radius: 8;
			antialiasing: true;
			x: xpos; y: ypos;
			
			states: State {
				when: mouseAreaItem.drag.active
				PropertyChanges {
					target: wrapper; radius: 100;
				}
			}
			
			MouseArea {
				id: mouseAreaItem
				anchors.fill: parent;
				onPressed: {
					console.log(todoList.get(index).name);
					showCurrent.text = todoList.get(index).name;
					page.currentItem = index;
					//if (mouse.modifiers & Qt.ShiftModifier) {
					//	console.log("shift!");
					//}
				}
				onPressAndHold: {
					showCurrent.text = todoList.get(index).name;
					page.currentItem = index;
				}
				onReleased: {
					console.log("mouseX: " + wrapper.x);
					if (wrapper.x > (customWidth - 35) && wrapper.y < 30) {
						Todo.deleteItem(todoList, page);
					} else {
						todoList.get(index).xpos = wrapper.x;
						todoList.get(index).ypos = wrapper.y;
					}
				}
				drag.target: wrapper;
				drag.axis: Drag.XAndYAxis;

			}
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

} 
