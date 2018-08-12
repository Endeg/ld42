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
	hpLabel.text = "HP: " + var2str(global.happyPoints)
	xpLabel.text = "XP: " + var2str(global.currentXp) + "/" + var2str(global.goalXp)
	lvlLabel.text = "LVL: " + var2str(global.level)
