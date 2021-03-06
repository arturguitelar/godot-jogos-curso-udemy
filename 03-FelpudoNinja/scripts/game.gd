extends Node2D

# referências para os nodes
onready var fruits = get_node("Fruits")
onready var score_label = get_node("Control/ScoreLabel")
onready var bomb_1 = get_node("Control/Bomb1")
onready var bomb_2 = get_node("Control/Bomb2")
onready var bomb_3 = get_node("Control/Bomb3")
onready var input_processor = get_node("InputProcessor")
onready var game_over_screen = get_node("GameOverScreen")

# referências para as frutas
var avocado = preload("res://scenes//avocado.tscn")
var banana = preload("res://scenes//banana.tscn")
var lemon = preload("res://scenes//lemon.tscn")
var orange = preload("res://scenes//orange.tscn")
var pear = preload("res://scenes//pear.tscn")
var pineapple = preload("res://scenes//pineapple.tscn")
var tomato = preload("res://scenes//tomato.tscn")
var watermelon = preload("res://scenes//watermelon.tscn")

# referência para a bomba
var bomb = preload("res://scenes//bomb.tscn")

# var internas
var score = 0
var lifes = 3

func _ready():
	pass

# gera as frutas e as bombas aleatoriamente
func _on_Generator_timeout():
	if lifes <= 0: return
	
	# a quantidade é de 1 a 3 frutas por vêz
	for i in range(0, rand_range(1, 4)):
		# o tipo do objeto gerado varia entre 0 e 7 para uma fruta e 8 para uma bomba
		var type = int(rand_range(0, 9))
		var obj = getObj(type)
		
		obj.spawn(Vector2(rand_range(200, 1080), 800))
		
		obj.connect("life", self, "dec_life")
		
		# são 8 frutas até o momento
		if type <= 8:
			obj.connect("score", self, "add_score")
		
		fruits.add_child(obj)

# retorna um objeto (fruta ou bomba) de acordo com um tipo pre-definido
# o tipo pode ser um número de 0 a 7, para uma fruta, ou outro valor para um bomba
func getObj(type):
	if type == 0:
		return avocado.instance()
	elif type == 1:
		return banana.instance()
	elif type == 2:
		return lemon.instance()
	elif type == 3:
		return orange.instance()
	elif type == 4:
		return pear.instance()
	elif type == 5:
		return pineapple.instance()
	elif type == 6:
		return tomato.instance()
	elif type == 7:
		return watermelon.instance()
	else:
		return bomb.instance() #bomb

# diminui a quantidade de vidas
func dec_life():
	lifes -= 1
	
	if lifes == 0: 
		input_processor.endgame = true
		bomb_1.set_modulate(Color(1, 0, 0))
		game_over_screen.start()
	
	# modificando os outros marcadores de vida (bombas na direita da tela)
	if lifes == 2: bomb_3.set_modulate(Color(1, 0, 0))
	if lifes == 1: bomb_2.set_modulate(Color(1, 0, 0))

# adiciona pontos ao score
func add_score():
	if lifes <= 0: return
	
	score += 1
	score_label.set_text(str(score))
