extends Node2D

#TODO: Fix typos in "dissapear"
const DISSAPEAR_ANIMATIONS = [
	"Dissapear1",
	"Dissapear2"
]

const APPEAR_ANIMATIONS = [
	"Appear1",
]

var itemType = null

func setType(typeName):
	itemType = typeName
	for child in $Graphic.get_children():
		child.visible = child.name == typeName

func scheduleForDeletion():
	queue_free()

func startRemoving():
	$AnimationPlayer.play(DISSAPEAR_ANIMATIONS[randi() % DISSAPEAR_ANIMATIONS.size()], 0.5)

func startAppearing():
	$AnimationPlayer.play(APPEAR_ANIMATIONS[randi() % APPEAR_ANIMATIONS.size()], 0.75)
