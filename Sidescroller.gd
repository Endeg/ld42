extends Node2D

const SPEED = 100
const BG_WIDTH = 3584

var items = null
var global = null
var backpack = null
var bg = null
var fg = null

var itemClass = load("res://Item.tscn")

var moving = false

func _ready():
	set_process(true)
	items = $Hero/Items
	assert items != null
	
	backpack = get_node("../Backpack")
	assert backpack != null	
	
	global = get_node("/root/Global")
	
	bg = $Background
	fg = $Foreground
	
func _process(delta):
	if moving:
		for child in items.get_children():
			if not child.removing and not child.skipped:
				child.position.x -= delta * global.speed * SPEED
			
			if not child.removing and not child.skipped and child.position.x < 0.0:
				if backpack.slots.addItem(child.itemType):
					child.startRemoving()
					$PickupItemSound.play()
				else:
					global.fineForSkippingItem()
					child.skip()
					$HurtSound.play()

		for child in bg.get_children():
			child.position.x -= delta * global.speed * SPEED
			if child.position.x < -BG_WIDTH:
				child.position.x += BG_WIDTH * 2
				
		for child in fg.get_children():
			child.position.x -= delta * global.speed * SPEED * 1.8
			if child.position.x < -BG_WIDTH:
				child.position.x += BG_WIDTH * 2

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
		
		#print("Item added.")

func _on_Timer_timeout():
	var dice = randi() % 50
	if dice > 44:
		spawnGroupOfItems(10)
	elif dice > 25:
		spawnGroupOfItems(7)
	elif dice > 10:
		spawnGroupOfItems(4)

var portrait = null

func setPlayerIcon(portrait):
	self.portrait = portrait
	$"Hero/Graphic/sorceress-icon".visible = portrait == "sorceress"
	$"Hero/Graphic/knight-icon".visible = portrait == "knight"
	$"Hero/Graphic/ninja-icon".visible = portrait == "ninja"
	
func heroFall():
	var heroIcon = get_node("Hero/Graphic/" + portrait + "-icon")
	assert heroIcon != null
	$Hero/AnimationPlayer.play("Idle", 0.5)
	heroIcon.play("Fallen")
