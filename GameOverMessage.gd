extends Node2D

var global = null

func _ready():
	global = get_node("/root/Global")
	assert global != null


func _on_ResetButton_pressed():
	global.reset()
