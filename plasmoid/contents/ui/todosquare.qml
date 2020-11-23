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
import QtQml 2.0
import QtQuick.Layouts 1.0
import QtQuick.LocalStorage 2.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0
import org.kde.kquickcontrolsaddons 2.0

import "../code/database.js" as Db

Item {
	id: root;
	
	readonly property int customHeight: height;
	readonly property int customWidth: width;

	/* No support for CompactRepresentation, as it is probably
	 * not useful to run this widget in compact mode  */
	Plasmoid.preferredRepresentation: plasmoid.fullRepresentation;

	height: units.gridUnit * 14;
	width: units.gridUnit * 15;

	/* Force minimum size */
	Layout.minimumHeight: units.gridUnit * 10;
	Layout.minimumWidth: units.gridUnit * 12;

	Component.onCompleted: {
		Db.dbInit();
	}

	Grid {
		rows: 3;
		columns: 1;
		rowSpacing: 5;

		/* Square with todos */
		Rectangle {
			
			id: page
			height: root.height - 30; /* 30px reserved for lower footer */
			width: root.width;
			
			property int currentItem: -1;
			property alias introText: showCurrent.text;
			color: "#00000000"
	
			/* Trashbin */
			Rectangle {
				width: 30;
				height: 30;
				color: "transparent";
				anchors.left: page.right;
				anchors.leftMargin: -30;
	
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
	
		/* Seperator */
		Rectangle {
	
			color: "white";
			height: units.gridUnit * 0.1;
			width:	root.width;
		}

		/* Info about selected item */
		Rectangle {
			height: 10;
			width: root.width;
			color: "#00000000";
			
			Text {
				id: showCurrent;
				color: "white";
				text: "left-click: view | right-click: add";
				verticalAlignment: Text.AlignBottom;
			}
		}

	}

	/* Tiny textbox that appears when adding a new item */
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
				if (enterText.text != "") {
					Db.insertTodo(enter.x, enter.y, enterText.text);
					page.currentItem = todoList.count;
					showCurrent.text = enterText.text;
					todoList.update();
				}
				enter.visible = false;
				enterText.text = "";
			} else if (event.key == Qt.Key_Escape) {
				enter.visible = false;
				enterText.text = "";
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

			radius: 5;
			x: xpos; y: ypos;
			
			color: { Qt.rgba((y / page.height), 0, 0, (x / root.width) + 0.3); }
			
			MouseArea {
				id: mouseAreaItem
				anchors.fill: parent;
				onPressed: {
					showCurrent.text = todo
					page.currentItem = index;
				}
				//onPressAndHold: { /* Not needed? */
				//}
				onReleased: {
					if (wrapper.x > (customWidth - 35) && wrapper.y < 30) {
						page.currentItem = -1;
						showCurrent.text = "left-click: view | right-click: add";
						Db.deleteTodo(id);
						todoList.update();
					} else {
						/* Logic to 'clip' around the edges */
						wrapper.x = Math.max(0, wrapper.x);
						wrapper.x = Math.min(root.width - 10, wrapper.x);
						wrapper.y = Math.max(0, wrapper.y);
						wrapper.y = Math.min(root.height - 45, wrapper.y);
						Db.updateTodoPosition(id, wrapper.x, wrapper.y);
					}
				}
				drag.target: wrapper;
				drag.axis: Drag.XAndYAxis;

			}

			/* If item is selected, show an arrow */
			Image {
				x: 2;
				y: -12;
				visible: { index == page.currentItem ? true : false; }
				source: "../images/arrow.png"
			}
		}

	}
	
}
