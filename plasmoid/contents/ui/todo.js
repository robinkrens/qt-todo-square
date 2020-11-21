function deleteItem(todoList, elem) {
	if (elem.currentItem >= 0) {
		todoList.remove(elem.currentItem, 1);
		elem.currentItem = -1;
		elem.introText = "left-click: view | right-click: add | left-click drag: move";
	}
}
