extends Node

func _ready():
	pass

func remove():
	queue_free()

func turnSparkly():
	$Particles2D.emitting = true
