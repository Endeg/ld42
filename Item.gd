extends Node2D

var itemType = null

func setType(typeName):
	itemType = typeName
	for child in get_children():
		child.visible = child.name == typeName
