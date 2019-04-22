extends Node2D

onready var marker = get_node("Marker")

var percent = 1

signal lose

func _ready():
	set_process(true)

# Controla o tamanho da barra.
# Nota: A popriedade Region Rect do sprite Marker foi modificada no inspetor para:
# (0, 0, 188, 23). utiliza-se essa região para mostrar a barra de acordo com uma porcentagem.
func _process(delta):
	if percent > 0:
		percent -= 0.1 * delta
		marker.set_region_rect(Rect2(0, 0, percent * 188, 23))
		marker.set_pos(Vector2(-(1-percent) * 188 / 2, 0))
	else:
		emit_signal("lose")

# Adiciona mais tempo à barra.
func add(delta):
	percent += delta
	if percent > 1: percent = 1