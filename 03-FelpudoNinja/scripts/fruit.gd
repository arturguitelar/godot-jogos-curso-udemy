extends RigidBody2D

const SCREEN_HEIGHT = 800

# referêcias para os nodes da cena
onready var shape = get_node("Shape")
onready var sprite_full = get_node("SpriteFull")
onready var piece_left = get_node("PieceLeft")
onready var piece_right = get_node("PieceRight")
onready var sprite_left = piece_left.get_node("SpriteLeft")
onready var sprite_right = piece_right.get_node("SpriteRight")

var fruit_cut = false

signal score
signal life

func _ready():
	randomize()
	set_process(true)
	spawn(Vector2(640, 640))

func _process(delta):
	# se a fruta "inteira" passou da parte inferior da tela
	# o player perde life e a fruta é excluída
	if get_pos().y > SCREEN_HEIGHT:
		print("perdeu")
		emit_signal("life")
		queue_free()
		
	# se a fruta "partida" passou da parte inferior da tela
	# os pontos ja foram contabilizados então a fruta é excluída
	if piece_left.get_pos().y > SCREEN_HEIGHT and piece_right.get_pos().y > SCREEN_HEIGHT:
		print("free!")
		queue_free()
# Cria uma fruta em uma posição delimitada e "joga" ela pra cima.
# A fruta fará uma parábola que muda dependendo da relação da posição
# em que ela surgiu com o lado esquerdo ou direito da tela.
# A idéia é que a parábola seja sempre contrária ao lado da tela onde
# a fruta saiu.
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

# Trata da parte do "corte" da fruta.
func cut():
	if fruit_cut: return
	
	fruit_cut = true
	set_mode(MODE_KINEMATIC)
	
	emit_signal("score")
	
	# elimina a fruta "inteira"
	sprite_full.queue_free()
	shape.queue_free()
	
	# e os dois pedaços da fruta caem
	# o lado esquerdo sai rotacionado para a esquerda e o direito para a direita
	piece_left.set_mode(MODE_RIGID)
	piece_right.set_mode(MODE_RIGID)
	piece_left.apply_impulse(Vector2(0, 0), Vector2(-100, 0).rotated(get_rot()))
	piece_right.apply_impulse(Vector2(0, 0), Vector2(100, 0).rotated(get_rot()))
	piece_left.set_angular_velocity(get_angular_velocity())
	piece_right.set_angular_velocity(get_angular_velocity())
	

func _on_Timer_timeout():
	cut()
