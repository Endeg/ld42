extends Node

const ITEM_TYPES = [
	"WhitePearl",
	"BlackPearl"
]

var speed = 1.0

func getRandomItemType():
	return ITEM_TYPES[randi() % ITEM_TYPES.size()]

func _ready():
	randomize()
