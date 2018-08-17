extends Node2D

var info

var valueNodes = {}

func _ready():
	info = $Info
	
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
