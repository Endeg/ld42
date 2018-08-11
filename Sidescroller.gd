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

func spawnGroupOfItems(count):
	var base = get_viewport().size.x - position.x + 200 + (randi() % 100) - 200
	for i in range(randi() % count):
		var itemInstance = itemClass.instance()
		itemInstance.setType(global.getRandomItemType())
		items.add_child(itemInstance)
		
		itemInstance.position.x = base
		itemInstance.position.y = 0
		itemInstance.scale = Vector2(0.25, 0.25)
		
		base += randi() % 10 - 20
		
		print("Item added.")

func _on_Timer_timeout():
	var dice = randi() % 50
	
	if dice > 44:
		spawnGroupOfItems(10)
	elif dice > 25:
		spawnGroupOfItems(7)
	elif dice > 10:
		spawnGroupOfItems(4)
