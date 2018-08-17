extends Node2D

var info
var global
var backpack

var valueNodes = {}

func _ready():
	info = $Info
	backpack = $"../Backpack"
	global = get_node("/root/Global")
	
func _exit_tree():
	valueNodes.clear()

func setEntry(entryName, value):
	if not visible:
		return

	var valueLabel = null
	
	if valueNodes.has(entryName):
		valueLabel = valueNodes[entryName]
	else:
		valueLabel = Label.new()
		valueNodes[entryName] = valueLabel
		var nameLabel = Label.new()
		nameLabel.text = entryName + ":"
		
		info.add_child(nameLabel)
		info.add_child(valueLabel)

	valueLabel.text = var2str(value)


func _on_ResetButton_pressed():
	global.reset()

func _on_AddItemButton_pressed():
	backpack.addItem(global.getRandomItemType())
