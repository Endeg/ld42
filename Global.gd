extends Node

const ITEM_TYPES = {
	0 : [
		"WhitePearl",
		"BlackPearl",
		"Coin",
		"BlueDiamond",
		"HealthPotion",
	]
}

const ITEM_WEALTH = {
	"WhitePearl" : 3,
	"BlackPearl" : 5,
	"Coin" : 7,
	"BlueDiamond": 16,
	"HealthPotion": 4,
}
var speed = 1.0

var happyPoints = 0
var maxHappyPoints = 0
var currentXp = 0
var goalXp = 0
var level = 0

var levelUpMessageClass = load("res://LevelUpMessage.tscn")
var gameOverMessageClass = load("res://GameOverMessage.tscn")

func resetStats():
	happyPoints = 30
	maxHappyPoints = 30
	currentXp = 0
	goalXp = 1000
	level = 0
	speed = 1.0

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
		goalXp = goalXp * 2.5
		speed = speed * 1.05
		maxHappyPoints += 2
		happyPoints = maxHappyPoints
		spawnLevelUpMessage()

	_updateStatusLabels()

func fineForSkippingItem():
	#TODO: Shake avatar
	happyPoints -= 1
	_updateStatusLabels()
	if happyPoints <= 0:
		spawnGameOverMessage()

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
	
func spawnLevelUpMessage():
	var levelUpNode = levelUpMessageClass.instance()
	var root = get_node("/root/Root")
	assert root != null
	root.add_child(levelUpNode)
	
func spawnGameOverMessage():
	var gameOverNode = gameOverMessageClass.instance()
	var root = get_node("/root/Root")
	assert root != null
	root.stop()
	root.add_child(gameOverNode)
