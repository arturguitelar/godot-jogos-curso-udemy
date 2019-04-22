extends Node2D

onready var idle = get_node("Idle")
onready var hiting = get_node("Hiting")
onready var grave = get_node("Grave")
onready var anim = get_node("Anim")

var side

const LEFT = -1
const RIGHT = 1

func _ready():

	pass

# move player para a esquerda
func toLeft():
	set_pos(Vector2(220, 1070))
	idle.set_flip_h(false)
	hiting.set_flip_h(false)
	
	grave.set_pos(Vector2(-44, 41))
	grave.set_flip_h(true)
	
	side = LEFT

# move player para a direita.
func toRight():
	set_pos(Vector2(500, 1070))
	idle.set_flip_h(true)
	hiting.set_flip_h(true)
	
	grave.set_pos(Vector2(28, 41))
	grave.set_flip_h(false)
	
	side = RIGHT

# Player bate.
func hit():
	anim.play("Hit")

# Morte do player
func die():
	anim.stop()
	idle.hide()
	hiting.hide()
	grave.show()
