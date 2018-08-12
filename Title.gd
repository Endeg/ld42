extends Node2D

var global = null
var sidescroller = null
var status = null

func _ready():
	global = get_node("/root/Global")
	assert global != null
	
	sidescroller = get_node("../Sidescroller")
	assert sidescroller != null
	
	status = get_node("../Status")
	assert sidescroller != null


func startWithSpeed(speed):
	global.speed = speed
	$AnimationPlayer.play("Dissolve")
	sidescroller.moving = true

func scheduleForRemoval():
	queue_free()

func _on_Knight_pressed():
	startWithSpeed(1.0)
	status.setPortrait("knight")

func _on_Sorceress_pressed():
	startWithSpeed(1.8)
	status.setPortrait("sorceress")

func _on_Ninja_pressed():
	startWithSpeed(3.0)
	status.setPortrait("ninja")
