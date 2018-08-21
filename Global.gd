extends Node

const ITEM_TYPES = {
	0 : [
		"Coin",
		#"HealthPotion",
		#"ManaPotion",
	],
	
	1 : [
		"Coin",
		"HealthPotion",
		"ManaPotion",
	],
	
	2 : [
		"Coin",
		"HealthPotion",
		"ManaPotion",
	],
	
	3 : [
		"Coin",
		"HealthPotion",
		"ManaPotion",
		"WhitePearl",
		"BlackPearl",
		"Amethyst",
	],
	
	4 : [
		"Coin",
		"HealthPotion",
		"ManaPotion",
		"WhitePearl",
		"BlackPearl",
		"Amethyst",
	],
	
	5 : [
		"Coin",
		"HealthPotion",
		"ManaPotion",
		"WhitePearl",
		"BlackPearl",
		"Amethyst",
		"BlueDiamond",
		"Emerald",
	],
	
	6 : [
		"Coin",
		"HealthPotion",
		"ManaPotion",
		"WhitePearl",
		"BlackPearl",
		"Amethyst",
		"BlueDiamond",
		"Emerald",
	],
	
	7 : [
		"WhitePearl",
		"BlackPearl",
		"Coin",
		"BlueDiamond",
		"Amethyst",
		"Emerald",
		"HealthPotion",
		"ManaPotion",
		"LiterallySpider",
		"Skull",
	]
}

const ITEM_WEALTH = {
	#Level 0-2
	"Coin" : 7,
	"HealthPotion": 4,
	"ManaPotion": 6,
	
	#Level 3-4
	"WhitePearl" : 8,
	"BlackPearl" : 12,
	"Amethyst": 14,
	
	#Level 5-6
	"BlueDiamond": 20,
	"Emerald": 16,	
	
	#Level 7-n
	"LiterallySpider": 25,
	"Skull": 35,
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

	_updateStatusLabels(null)

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

	currentXp += wealth * scoreMultiplicator + ((10 + level * 10) / 10)
	
	if currentXp >= goalXp:
		level += 1
		goalXp = goalXp * 1.8
		speed = speed * 1.05
		maxHappyPoints += 2
		happyPoints = maxHappyPoints
		spawnLevelUpMessage()

	_updateStatusLabels("Happy")

func fineForSkippingItem():
	#TODO: Shake avatar
	happyPoints -= 1
	_updateStatusLabels("Hurt")
	if happyPoints <= 0:
		spawnGameOverMessage()

func _updateStatusLabels(reason):
	var statusNode = get_node("/root/Root/Status")
	if statusNode != null:
		statusNode.update()
		if reason != null:
			for child in statusNode.get_node("Portrait").get_children():
				child.play("default")
				child.play(reason)

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
