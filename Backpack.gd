extends Node2D

const BOARD_WIDTH = 14
const BOARD_HEIGHT = 7

const SLOT_SIZE = 64

const MATCH_RANGES = [5, 4, 3]

var board = {}

var global = null

var itemClass = load("res://Item.tscn")

var cursor = null

var currentCursorPos = Vector2(0, 0)

var selectedSlotStart = null

func _ready():
	global = get_node("/root/Global")
	assert global != null
	
	cursor = $Cursor
	assert cursor != null

func _input(event):
	if event is InputEventMouseMotion:
		var mousePos = get_viewport().get_mouse_position()
		mousePos = mousePos - position
		
		cursor.visible = false
		
		if mousePos.x > 0 and mousePos.y > 0 and mousePos.x < BOARD_WIDTH * SLOT_SIZE and mousePos.y < BOARD_HEIGHT * SLOT_SIZE:
			cursor.visible = true
			currentCursorPos.x = int(mousePos.x / SLOT_SIZE)
			currentCursorPos.y = int(mousePos.y / SLOT_SIZE)
			cursor.position.x = currentCursorPos.x * SLOT_SIZE
			cursor.position.y = currentCursorPos.y * SLOT_SIZE
		_updateDebugSlot()
	elif event is InputEventMouseButton:
		if event.pressed and currentCursorPos.x >= 0 and currentCursorPos.y >= 0 and currentCursorPos.x < BOARD_WIDTH and currentCursorPos.y < BOARD_HEIGHT:
			if board.has(currentCursorPos):
				selectedSlotStart = currentCursorPos
				_animateSelectedItemAt(selectedSlotStart)
				#TODO: Animate selected item
			elif selectedSlotStart != null and _reachableSlot(selectedSlotStart, currentCursorPos):
				_moveItem(selectedSlotStart, currentCursorPos)
				#TODO: Move animation
				selectedSlotStart = null
			
		_updateDebugSlot()

func _animateSelectedItemAt(selectedKey):
	for key in board.keys():
		var itemNode = _getItemNodeAt(selectedSlotStart)
		if key == selectedKey:
			itemNode.select()
		else:
			itemNode.deselect()

func _reachableSlot(src, dest):
	#TODO: implement if restrictions will look necessary
	return true
	
func _moveItem(src, dest):
	print("Moving item from ", src, " to ", dest)
	var itemNode = _getItemNodeAt(src)
	itemNode.targetPos = Vector2(dest.x * SLOT_SIZE + (SLOT_SIZE / 2), dest.y * SLOT_SIZE + (SLOT_SIZE / 2))
	board[dest] = board[src]
	board.erase(src)
	_checkMatches()

func _findFreeSpace():
	for y in range(BOARD_HEIGHT):
		for x in range(BOARD_WIDTH):
			if not board.has(Vector2(x, y)):
				return [x, y]
	return []

func _createItemAt(itemType, x, y):
	var itemInstance = itemClass.instance()
	itemInstance.setType(itemType)
	itemInstance.position = Vector2(x * SLOT_SIZE + (SLOT_SIZE / 2), y * SLOT_SIZE + (SLOT_SIZE / 2))
	add_child(itemInstance)
	itemInstance.startAppearing()
	
	#print("Board set " + var2str(x) + "x" + var2str(y) + " to '" + itemInstance.name + "'")
	board[Vector2(x, y)] = itemInstance.name
	
	_checkMatches()

func _getItemNodeAt(key):
	var instanceName = board[key]
	var itemNode = get_node("./" + instanceName)
	assert itemNode != null
	return itemNode

func _getItemTypeAt(x, y):
	var key = Vector2(x, y)
	if board.has(key):
		var itemNode = _getItemNodeAt(key)
		return itemNode.itemType
	
	return null
	
func _checkMatches():
	for y in range(BOARD_HEIGHT):
		for x in range(BOARD_WIDTH):
			var rootItemType = _getItemTypeAt(x, y)
			if rootItemType == null:
				continue

			for i in MATCH_RANGES:
				#Horizontal lines
				if _figureMatches(x, y, x + i - 1, y, rootItemType):
					_removeFigure(x, y, x + i - 1, y, rootItemType, i)
				#Vertical lines
				if _figureMatches(x, y, x, y + i - 1, rootItemType):
					_removeFigure(x, y, x, y + i - 1, rootItemType, i)
				#TODO: Diagonal lines?

func _figureMatches(left, top, right, bottom, itemType):
	var result = true
	for x in range(left, right + 1):
		for y in range(top, bottom + 1):
			var itemTypeToCheck = _getItemTypeAt(x, y)
			var matching = itemTypeToCheck == itemType
			result = result and matching
			if not result:
				return result
	return result

func _removeFigure(left, top, right, bottom, itemType, scoreMultiplicator):
	#TODO: apply score according to item and multiplicator
	#print("Should remove figure: left=" + var2str(left) + ", top=" + var2str(top) + ", right=" + var2str(right) + ", bottom=" + var2str(bottom))
	for x in range(left, right + 1):
		for y in range(top, bottom + 1):
			_clearItemAt(x, y)

func _clearItemAt(x, y):
	var key = Vector2(x, y)
	if selectedSlotStart == key:
		selectedSlotStart = null
		_updateDebugSlot()
	
	assert board.has(key)
	
	var instanceName = board[key]
	assert instanceName != null
	var itemNode = get_node("./" + instanceName)
	itemNode.startRemoving()
	
	board.erase(key)

func addItem(itemType):
	var freeSpace = _findFreeSpace()
	if freeSpace != []:
		var x = freeSpace[0]
		var y = freeSpace[1]
		
		_createItemAt(itemType, x, y)

		return true
	else:
		return false

func _updateDebugSlot():
	var startSlotLabel = get_node("../DebugPanel/StartSlot")
	if startSlotLabel != null:
		startSlotLabel.text = "Start: " + var2str(selectedSlotStart)
		
	var cursorLabel = get_node("../DebugPanel/Cursor")
	if cursorLabel != null:
		cursorLabel.text = "Cursor: " + var2str(currentCursorPos)
	