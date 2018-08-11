extends Node2D

const MOVE_SPEED = 1.2

#TODO: Fix typos in "dissapear"
const DISSAPEAR_ANIMATIONS = [
	"Dissapear1",
	"Dissapear2"
]

const APPEAR_ANIMATIONS = [
	"Appear1",
]

var itemType = null

var removing = false
var skipped = false

var targetPos = null
var moveWeight = 0.0

func _ready():
	$Label.text = name
	set_process(true)

func _process(delta):
	if targetPos != null:
		moveWeight += delta * MOVE_SPEED
		if moveWeight > 1.0:
			moveWeight = 1.0
		position.x = lerp(position.x, targetPos.x, moveWeight)
		position.y = lerp(position.y, targetPos.y, moveWeight)
		if targetPos == position:
			targetPos = null
			moveWeight = 0.0

func setType(typeName):
	itemType = typeName
	for child in $Graphic.get_children():
		child.visible = child.name == typeName

func scheduleForDeletion():
	#print("Item: ", name, " to be deleted")
	queue_free()

func startRemoving():
	if not removing:
		$AnimationPlayer.play(DISSAPEAR_ANIMATIONS[randi() % DISSAPEAR_ANIMATIONS.size()], 0.5)
		removing = true

func startAppearing():
	$AnimationPlayer.play(APPEAR_ANIMATIONS[randi() % APPEAR_ANIMATIONS.size()], 0.75)
