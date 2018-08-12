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

var happyPoints = 0
var currentXp = 0
var goalXp = 0
var level = 0

func resetStats():
	happyPoints = 30
	currentXp = 0
	goalXp = 1000
	level = 0
	
	_updateStatusLabels()

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

func applyScore(itemType, scoreMultiplicator):
	var wealth = 1
	if ITEM_WEALTH.has(itemType):
		wealth = ITEM_WEALTH[itemType]

	currentXp += wealth * scoreMultiplicator
	
	if currentXp >= goalXp:
		level += 1
		#TODO: Level up effect
		goalXp = goalXp * 2.5
		speed = speed * 1.05

	_updateStatusLabels()

func _updateStatusLabels():
	var statusNode = get_node("/root/Root/Status")
	if statusNode != null:
		statusNode.update()

func _ready():
	print(name, " is ready")
	randomize()

func reset():
	get_tree().reload_current_scene()
	resetStats()
