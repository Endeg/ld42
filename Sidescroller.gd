extends Node2D

const SPEED = 100

var items = null
var global = null
var backpack = null

var itemClass = load("res://Item.tscn")

var moving = true

func _ready():
	set_process(true)
	items = $Items
	assert items != null
	
	backpack = get_node("../Backpack")
	assert backpack != null	
	
	global = get_node("/root/Global")
	
func _process(delta):
	if moving:
		for child in items.get_children():
			child.position.x -= delta * global.speed * SPEED
			
			if not child.removing and child.position.x < 0.0:
				backpack.addItem(child.itemType)
				child.startRemoving()


func _on_Timer_timeout():
	var base = 1300
	for i in range(randi() % 10):
		var itemInstance = itemClass.instance()
		itemInstance.setType(global.getRandomItemType())
		items.add_child(itemInstance)
		
		itemInstance.position.x = base
		itemInstance.position.y = 0
		itemInstance.scale = Vector2(0.25, 0.25)
		
		base += randi() % 5
		
		print("Item added.")
