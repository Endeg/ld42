extends Node2D

var cursor = null

var currentCursorPos = Vector2(0, 0)

var selectedSlot = null

var status = null

var debugPanel = null

var slots

func _ready():
	cursor = $Cursor
	assert cursor != null
	
	status = get_node("../Status")
	assert status != null
	
	debugPanel = get_node("../DebugPanel")
	assert debugPanel != null
	
	slots = $Slots
	
	connect("item_cleared", self, "handleItemClear")

func _input(event):
	if event is InputEventMouseMotion:
		var mousePos = get_viewport().get_mouse_position()
		mousePos = mousePos - position
		
		cursor.visible = false
		
		if mousePos.x > 0 and mousePos.y > 0 and mousePos.x < slots.BOARD_WIDTH * slots.SLOT_SIZE and mousePos.y < slots.BOARD_HEIGHT * slots.SLOT_SIZE:
			cursor.visible = true
			currentCursorPos.x = int(mousePos.x / slots.SLOT_SIZE)
			currentCursorPos.y = int(mousePos.y / slots.SLOT_SIZE)
			cursor.position.x = currentCursorPos.x * slots.SLOT_SIZE
			cursor.position.y = currentCursorPos.y * slots.SLOT_SIZE
			
		debugPanel.setEntry("Cursor pos", currentCursorPos)
	elif event is InputEventMouseButton:
		var mousePos = get_viewport().get_mouse_position()
		mousePos = mousePos - position
		
		var insideBoard = mousePos.x > 0 and mousePos.y > 0 and mousePos.x < slots.BOARD_WIDTH * slots.SLOT_SIZE and mousePos.y < slots.BOARD_HEIGHT * slots.SLOT_SIZE
		
		if insideBoard and event.pressed and currentCursorPos.x >= 0 and currentCursorPos.y >= 0 and currentCursorPos.x < slots.BOARD_WIDTH and currentCursorPos.y < slots.BOARD_HEIGHT:
			if selectedSlot == null and slots.isFilled(currentCursorPos):
				selectedSlot = currentCursorPos
				slots.animateSelectedItemAt(selectedSlot)
			elif selectedSlot != null and slots.isFilled(currentCursorPos):
				slots.swapItemsAt(selectedSlot, currentCursorPos)
				selectedSlot = null
			elif selectedSlot != null and slots.reachableSlot(selectedSlot, currentCursorPos):
				slots.moveItem(selectedSlot, currentCursorPos)
				selectedSlot = null
			
		debugPanel.setEntry("Selected slot", selectedSlot)

func handleItemClear(key):
	if selectedSlot == key:
		selectedSlot = null
		debugPanel.setEntry("Selected slot", selectedSlot)
