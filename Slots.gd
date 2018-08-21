extends Sprite

const BOARD_WIDTH = 14
const BOARD_HEIGHT = 7

const SLOT_SIZE = 64

const MATCH_RANGES = [5, 4, 3]

const INITIAL_COOLDOWN = 0.5

signal item_cleared

var itemClass = preload("res://Item.tscn")

var board = {}
var cooldown = {}

var global

func _ready():
	global = get_node("/root/Global")
	assert global != null
	
	set_process(true)
	
	connect("item_cleared", get_parent(), "handleItemClear")

func _process(delta):
	for key in cooldown.keys():
		var value = cooldown[key]
		if value > 0:
			value -= delta
			cooldown[key] = value
		else:
			cooldown.erase(key)

func _exit_tree():
	board.clear()

func addItem(itemType):
	var freeSpace = _findFreeSpace()
	if freeSpace != []:
		var x = freeSpace[0]
		var y = freeSpace[1]
		
		_createItemAt(itemType, x, y)

		return true
	else:
		return false

func isFilled(slotPos):
	return board.has(slotPos)

func animateSelectedItemAt(selectedKey):
	for key in board.keys():
		var itemNode = board[key]
		if key == selectedKey:
			itemNode.select()
		else:
			itemNode.deselect()

func reachableSlot(src, dest):
	#TODO: implement if restrictions will look necessary
	return true
	
func moveItem(src, dest):
	var itemNode = board[src]
	itemNode.targetPos = slotsPos(dest.x, dest.y)
	itemNode.deselect()
	board[dest] = board[src]
	cooldown.erase(dest)
	board.erase(src)
	_checkMatches()
	
func swapItemsAt(a, b):
	var itemANode = board[a]
	var itemBNode = board[b]
	
	itemANode.targetPos = slotsPos(b.x, b.y)
	itemANode.deselect()
	
	itemBNode.targetPos = slotsPos(a.x, a.y)
	itemBNode.deselect()
	
	var tmp = board[a]
	board[a] = board[b]
	board[b] = tmp
	
	_checkMatches()

func _createItemAt(itemType, x, y):
	var itemInstance = itemClass.instance()
	itemInstance.setType(itemType)
	itemInstance.position = slotsPos(x, y)
	add_child(itemInstance)
	itemInstance.startAppearing()

	board[Vector2(x, y)] = itemInstance
	
	_checkMatches()

func slotsPos(x, y):
	return Vector2(x * SLOT_SIZE + (SLOT_SIZE / 2), y * SLOT_SIZE + (SLOT_SIZE / 2))

func _getItemTypeAt(x, y):
	var key = Vector2(x, y)
	if board.has(key):
		var itemNode = board[key]
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
	$MatchSound.play()
	for x in range(left, right + 1):
		for y in range(top, bottom + 1):
			_clearItemAt(x, y, itemType, scoreMultiplicator)

func _clearItemAt(x, y, itemType, scoreMultiplicator):
	var key = Vector2(x, y)
	
	emit_signal("item_cleared", key)
	
	assert board.has(key)

	var itemNode = board[key]
	itemNode.startRemoving()
	
	board.erase(key)
	cooldown[key] = INITIAL_COOLDOWN
	
	global.applyScore(itemType, scoreMultiplicator)


func _findFreeSpace():
	for y in range(BOARD_HEIGHT):
		for x in range(BOARD_WIDTH):
			var pos = Vector2(x, y)
			if not board.has(pos) and not cooldown.has(pos):
				return [x, y]
	return []
