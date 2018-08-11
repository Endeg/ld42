extends Node

var backpack = null
var global = null

func _ready():
	backpack = $Backpack
	global = get_node("/root/Global")

func _on_AddItemButton_pressed():
	backpack.addItem(global.getRandomItemType())
