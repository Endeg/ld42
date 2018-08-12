extends Node

const ITEM_TYPES = {
	0 : [
		"WhitePearl",
		"BlackPearl"
	]
}

const ITEM_WEALTH = {
	"WhitePearl" : 3,
	"BlackPearl" : 5,
}

var speed = 1.0

var happyPoints = 30
var currentXp = 0
var goalXp = 0
var level = 0

func getRandomItemType():
	var currentLevel = -1
	if ITEM_TYPES.has(level):
		currentLevel = level
	else:
		for key in ITEM_TYPES.keys():
			if key > currentLevel:
				currentLevel = key

	var itemTypesForLevel = ITEM_TYPES[currentLevel]
	return itemTypesForLevel[randi() % itemTypesForLevel.size()]

func _ready():
	randomize()

func reset():
	happyPoints = 30
	currentXp = 0
	goalXp = 0
	level = 0
	get_tree().reload_current_scene()
