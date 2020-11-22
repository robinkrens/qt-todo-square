/*
 *   Copyright 2020 Robin Krens <robin@robinkrens.nl>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0
import org.kde.kquickcontrolsaddons 2.0
import QtQuick.LocalStorage 2.0
import "../code/database.js" as Db

Item {
	property int customHeight: height;
	property int customWidth: width;

	id: root
	
	Plasmoid.preferredRepresentation: plasmoid.fullRepresentation;

	height: units.gridUnit * 14;
	width: units.gridUnit * 15;

	Component.onCompleted: {
		Db.dbInit();
	}
	

	Grid {
		rows: 3;
		columns: 1;
		rowSpacing: 5;

	Rectangle {
		
		id: page
		height: units.gridUnit * 12;
		width: units.gridUnit * 15;
		
		property int currentItem: -1;
		property alias introText: showCurrent.text;
		color: "#00000000"

		Rectangle {
			width: 30;
			height: 30;
			color: "transparent";
			anchors.left: page.right;
			anchors.leftMargin: -40;

			Image {
				anchors.fill: parent
				source: "../images/trash.png"
		      	}
	        }

		ListModel {
			id: todoList;
			signal update();
			Component.onCompleted: 
			{
				Db.readTodos();
			}
			onUpdate: {
				todoList.clear();
				Db.readTodos();
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
				    	//console.log("x:" + mouseX, " y:" + mouseY);
					//todoText.visibility = true;
					//todoText.clickedX = mouseX;
					//todoText.clickedY = mouseY;
					//todoText.emptyText = "";
					enter.x = mouseX;
					enter.y = mouseY;
					enter.visible = true;
				}
				//else if (mouse.button == Qt.LeftButton) {
				//	console.log("view");
				//}
			}
		}

	}

	Rectangle {

		color: "white";
		height: units.gridUnit * 0.1;
		width: units.gridUnit * 15;
	}
	
	Rectangle {
		height: units.gridUnit * 2;
		width: units.gridUnit * 15;
		color: "#00000000";
		
		Text {
			id: showCurrent;
			//anchors.fill: parent;
			color: "white";
			text: "left-click: view | right-click: add";
			verticalAlignment: Text.AlignBottom;
		}
	}

	}

	Rectangle {
		id: enter;
		x: 0;
		y: 0;
		width: 150;
		height: 35;
		radius: 5;
		visible: false;
		color: "white";

		Keys.onPressed: {
			if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
				Db.insertTodo(enter.x, enter.y, enterText.text);
				page.currentItem = todoList.count;
				showCurrent.text = enterText.text;
				todoList.update();
				enter.visible = false;
				enterText.text = "";
			} else if (event.key == Qt.Key_Escape) {
				enter.visible = false;
			}
		}

		TextField {
			focus: true;
			id: enterText;
			anchors.fill: parent;
		}
	}

	Component {
		id: todoDelegate
		Rectangle { 
			id: wrapper
			width: 12; height: 12;
			color: { index == page.currentItem ? "red" : "black"; }
			radius: 5;
			x: xpos; y: ypos;
			
			MouseArea {
				id: mouseAreaItem
				anchors.fill: parent;
				onPressed: {
					showCurrent.text = todo
					page.currentItem = index;
				}
				//onPressAndHold: {
				//	showCurrent.text = todoList.get(index).name;
				//	page.currentItem = index;
				//}
				onReleased: {
					//console.log("mouseX: " + wrapper.x);
					if (wrapper.x > (customWidth - 35) && wrapper.y < 30) {
						page.currentItem = -1;
						showCurrent.text = "left-click: view | right-click: add";
						Db.deleteTodo(id);
						todoList.update();
					} else {
						wrapper.x = Math.max(0, wrapper.x);
						wrapper.x = Math.min(root.width - 10, wrapper.x);
						wrapper.y = Math.max(0, wrapper.y);
						wrapper.y = Math.min(root.height - 50, wrapper.y);
						Db.updateTodoPosition(id, wrapper.x, wrapper.y);
					}
				}
				drag.target: wrapper;
				drag.axis: Drag.XAndYAxis;

			}
		}
	}
	
	DialogEdit {
		id: todoText;
		onAdded: function(xpos, ypos, todo) {
			Db.insertTodo(xpos, ypos, todo);
			page.currentItem = todoList.count;
			showCurrent.text = todo;
			todoList.update();
		}
	}


}
