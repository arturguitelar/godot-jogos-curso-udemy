extends Node2D

# referências aos nodes
onready var sprite = get_node("Sprite")
onready var shape = get_node("Shape")
onready var anim = get_node("Animation")

signal life

var cut_bomb = false

func _ready():
	set_process(true)
	randomize()
	
func _process(delta):
	# a bomba sai da tela
	if get_pos().y > 800:
		queue_free()
	
# Cria a bomba em uma posição aleatória e "joga" ela pra cima
func spawn(position):
	set_pos(position)

	# A velocidade aleatória (entre -1000 e -800) em que a fruta será jogada pra cima
	var velocity = Vector2(0, rand_range(-1000, -800))

	# Neste caso, 640 é o meio da tela
	if position.x < 640:
		velocity = velocity.rotated(deg2rad(rand_range(0, -30)))
	else:
		velocity = velocity.rotated(deg2rad(rand_range(0, 30)))

	# Set nos valores de velocidade e velocidade angular da fruta
	set_linear_velocity(velocity)
	set_angular_velocity(rand_range(-10, 10))

# "cortando" a bomba
func cut():
	if cut_bomb: return
	
	cut_bomb = true
	#set_mode(MODE_KINEMATIC)
	
	emit_signal("life")
	anim.play("Explode")