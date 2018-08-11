extends Node2D

const DISSAPEAR_ANIMATIONS = [
	"Dissapear1",
	"Dissapear2"
]

var itemType = null

func setType(typeName):
	itemType = typeName
	for child in $Graphic.get_children():
		child.visible = child.name == typeName

func scheduleForDeletion():
	queue_free()

func startRemoving():
	$AnimationPlayer.play(DISSAPEAR_ANIMATIONS[randi() % DISSAPEAR_ANIMATIONS.size()])
