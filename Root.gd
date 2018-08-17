extends Node

var backpack = null
var sidescroller = null
var global = null

func _ready():
	backpack = $Backpack
	sidescroller = $Sidescroller
	global = get_node("/root/Global")
	global.resetStats()

func stop():
	backpack.set_process_input(false)
	sidescroller.moving = false
	sidescroller.heroFall()
