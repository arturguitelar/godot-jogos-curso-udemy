extends Node2D

func _ready():

	pass

# Destrói um barril
func destroyBarrel(sent):
	if (sent == -1):
		get_node("AnimationPlayer").play("toRight")
	else:
		get_node("AnimationPlayer").play("toLeft")