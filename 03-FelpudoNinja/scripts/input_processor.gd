extends Node2D

# referências aos nodes dentro do node InputProcessor
onready var interval_raycasts = get_node("IntervalBetweenRaycasts")
onready var touch_limit = get_node("TouchLimit")

var pressed = false
var drag = false

# posições relacionadas ao toque na tela
var current_touch_position = Vector2(0,0)
var previous_touch_position = Vector2(0,0)

var endgame = false

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	
func _fixed_process(delta):
	# para a utilização da função _draw()
	update()
	
	# Para criar um raycast (que será o "corte" na fruta) é preciso avaliar
	# a posição do toque e se o player está arrastando o dedo.
	# Então é preciso avaliar se existe algum objeto neste "caminho"
	# percorrido pelo arrastar de dedo.
	if can_draw():
		# armazena o "caminho" do arrastar de dedo na tela
		var space_state = get_world_2d().get_direct_space_state()
		var result = space_state.intersect_ray(previous_touch_position, current_touch_position)
				
		# se encontrar um objeto no caminho, chama o método "cut" deste objeto
		if not result.empty():
			result.collider.cut()
	

func _input(event):
	# torna o evento de toque um evento local para prevenir comportamentos
	# diferentes em cada tipo de tela
	event = make_input_local(event)
	
	# tratando os eventos de tocar e arrastar o dedo na tela
	if event.type == InputEvent.SCREEN_TOUCH:
		if event.pressed:
			pressed(event.pos)
		else:
			released()
	elif event.type == InputEvent.SCREEN_DRAG:
		drag(event.pos)

# quando ocorre o evento touch, o estado pressed muda para true,
# armazena-se a posição onde está sendo pressionado e inicia-se os timers
func pressed(pos):
	pressed = true
	previous_touch_position = pos
	interval_raycasts.start()
	touch_limit.start()

# quando tirar o dedo da tela, o estado de pressed e drag muda para false,
# os timers param e as posições de toque são resetadas
func released():
	pressed = false
	drag = false
	interval_raycasts.stop()
	touch_limit.stop()
	previous_touch_position = Vector2(0,0)
	current_touch_position = Vector2(0,0)

# ao arrastar o dedo na tela, armazena-se a posição atual
# e muda o estado de drag para true
func drag(pos):
	current_touch_position = pos
	drag = true

func _on_IntervalBetweenRaycasts_timeout():
	# isso acontece a cada 0.1s (tempo pre-definido no timer)
	previous_touch_position = current_touch_position

func _on_TouchLimit_timeout():
	released()

func _draw():
	# Verifica o rastro de dedo na tela para criar uma linha, simulando o "corte"
	if can_draw():
		draw_line(current_touch_position, previous_touch_position, Color(1, 0, 0), 10)

# verifica se o rastro pode ser desenhado na tela
func can_draw():
	return drag and current_touch_position != previous_touch_position and previous_touch_position != Vector2(0,0) and not endgame
