extends Node2D

const BOARD_WIDTH = 14
const BOARD_HEIGHT = 7

const SLOT_SIZE = 64

const MATCH_RANGES = [5, 4, 3]

var board = {}

var global = null

var itemClass = load("res://Item.tscn")

func _ready():
	global = get_node("/root/Global")
	assert global != null
	
	for i in range(3000):
		addItem(global.getRandomItemType())

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

func _getItemTypeAt(x, y):
	var key = Vector2(x, y)
	if board.has(key):
		var instanceName = board[key]
		var itemNode = get_node("./" + instanceName)
		assert itemNode != null
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
	print("Should remove figure: left=" + var2str(left) + ", top=" + var2str(top) + ", right=" + var2str(right) + ", bottom=" + var2str(bottom))
	for x in range(left, right + 1):
		for y in range(top, bottom + 1):
			_clearItemAt(x, y)

func _clearItemAt(x, y):
	var key = Vector2(x, y)
	
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
