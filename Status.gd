extends Node2D

var global = null
var hpLabel = null
var xpLabel = null
var lvlLabel = null

func _ready():
	global = get_node("/root/Global")
	assert global != null
	hpLabel = $HPLabel
	assert hpLabel != null
	xpLabel = $XPLabel
	assert xpLabel != null
	lvlLabel = $LVLLabel
	assert lvlLabel != null
	
func update():
	hpLabel.text = "HP: %d/%d" % [global.happyPoints, global.maxHappyPoints]
	xpLabel.text = "XP: %d/%d" % [global.currentXp, global.goalXp]
	lvlLabel.text = "LVL: %d" % global.level
