extends Node

func _ready():
	pass

func remove():
	queue_free()

func playSound():
	$LevelUpSound.play()

func turnSparkly():
	$Particles2D.emitting = true
