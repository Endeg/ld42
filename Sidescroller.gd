extends Node2D

var items = null
var global = null

func _ready():
	set_process(true)
	items = $Items
	assert items != null
	
	global = get_node("/root/Global")
	
func _process(delta):
	for child in items.get_children():
		child.position.x -= delta * global.speed
