extends Node

const ITEM_TYPES = [
	"WhitePearl",
	"BlackPearl"
]

var speed = 1.0

var happyPoints = 30
var currentXp = 0
var goalXp = 0
var level = 0

func getRandomItemType():
	return ITEM_TYPES[randi() % ITEM_TYPES.size()]

func _ready():
	randomize()

func reset():
	happyPoints = 30
	currentXp = 0
	goalXp = 0
	level = 0
	get_tree().reload_current_scene()