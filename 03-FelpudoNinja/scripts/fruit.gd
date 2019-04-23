extends RigidBody2D

# referêcias para os nodes da cena
onready var shape = get_node("Shape")
onready var sprite0 = get_node("Sprite0")
onready var body1 = get_node("Body1")
onready var body2 = get_node("Body2")
onready var sprite1 = body1.get_node("Sprite1")
onready var sprite2 = body2.get_node("Sprite2")

func _ready():
	spawn(Vector2(640, 640))

# Cria uma fruta em uma posição delimitada e "joga" ela pra cima.
# A fruta fará uma parábola que muda dependendo da relação da posição
# em que ela surgiu com o lado esquerdo ou direito da tela.
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
