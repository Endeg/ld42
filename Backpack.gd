extends Node2D

const BOARD_WIDTH = 14
const BOARD_HEIGHT = 7

var board = {}

func _ready():
	pass

func _findFreeSpace():
	for x in range(BOARD_WIDTH):
		for y in range(BOARD_HEIGHT):
			if not board.has(Vector2(x, y)):
				return [x, y]
	return []

func addItem():
	pass
