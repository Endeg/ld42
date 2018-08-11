extends Node

var backpack = null
var global = null

func _ready():
	backpack = $Backpack
	global = get_node("/root/Global")

func _on_AddItemButton_pressed():
	backpack.addItem(global.getRandomItemType())

func _on_ResetButton_pressed():
	get_tree().reload_current_scene()
	#TODO: move it to Global.gd and reset gloabal vars
