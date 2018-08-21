extends Node2D

var global = null
var sidescroller = null
var status = null

var enabled = true

func _ready():
	global = get_node("/root/Global")
	assert global != null
	
	sidescroller = get_node("../Sidescroller")
	assert sidescroller != null
	
	status = get_node("../Status")
	assert sidescroller != null

func startWithSpeed(speed):
	if enabled:
		global.speed = speed
		$AnimationPlayer.play("Dissolve")
		sidescroller.moving = true
		sidescroller.get_node("Timer").start()
		$StartSound.play()

		enabled = false

func scheduleForRemoval():
	queue_free()

func _on_Knight_pressed():
	startWithSpeed(1.0)
	status.setPortrait("knight")
	sidescroller.setPlayerIcon("knight")

func _on_Sorceress_pressed():
	startWithSpeed(1.8)
	status.setPortrait("sorceress")
	sidescroller.setPlayerIcon("sorceress")

func _on_Ninja_pressed():
	startWithSpeed(3.0)
	status.setPortrait("ninja")
	sidescroller.setPlayerIcon("ninja")
