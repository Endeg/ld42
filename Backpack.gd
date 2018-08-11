extends Node2D

const BOARD_WIDTH = 14
const BOARD_HEIGHT = 7

const SLOT_SIZE = 64

var board = {}

var global = null

var itemClass = load("res://Item.tscn")

func _ready():
	global = get_node("/root/Global")
	assert global != null
	
	for i in range(100):
		addItem(global.getRandomItemType())

func _findFreeSpace():
	for y in range(BOARD_HEIGHT):
		for x in range(BOARD_WIDTH):
			if not board.has(Vector2(x, y)):
				return [x, y]
	return []

func addItem(itemType):
	var freeSpace = _findFreeSpace()
	if freeSpace != []:
		var x = freeSpace[0]
		var y = freeSpace[1]
		var itemInstance = itemClass.instance()
		itemInstance.setType(itemType)
		
		itemInstance.position = Vector2(x * SLOT_SIZE + (SLOT_SIZE / 2), y * SLOT_SIZE + (SLOT_SIZE / 2))
		
		add_child(itemInstance)
		
		print("Board set " + var2str(x) + "x" + var2str(y) + " to '" + itemInstance.name + "'")
		board[Vector2(x, y)] = itemInstance.name
		
		return true
	else:
		return false
