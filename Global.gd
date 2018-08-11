extends Node

const ITEM_TYPES = [
	"WhitePearl",
	"BlackPearl"
]

func getRandomItemType():
	return ITEM_TYPES[randi() % ITEM_TYPES.size()]

func _ready():
	randomize()
