extends Node2D

func _ready():
	pass

func setType(typeName):
	for child in get_children():
		child.visible = child.name == typeName
