extends Node2D

# referências para os nodes
onready var fruits = get_node("Fruits")

# referências para as frutas
var avocado = preload("res://scenes//avocado.tscn")
var banana = preload("res://scenes//banana.tscn")
var lemon = preload("res://scenes//lemon.tscn")
var orange = preload("res://scenes//orange.tscn")
var pear = preload("res://scenes//pear.tscn")
var pineapple = preload("res://scenes//pineapple.tscn")
var tomato = preload("res://scenes//tomato.tscn")
var watermelon = preload("res://scenes//watermelon.tscn")

var bomb = preload("res://scenes//bomb.tscn")

func _ready():
	
	pass

func _on_Generator_timeout():
	# gera as frutas aleatoriamente
	# a quantidade é de 1 a 3 frutas por vêz
	for i in range(0, rand_range(1, 4)):
		# o tipo do objeto gerado varia entre 0 e 7 para uma fruta e 8 para uma bomba
		var type = int(rand_range(0, 9))
		print(type)
		var obj = getObj(type)
		
		obj.spawn(Vector2(rand_range(200, 1080), 800))
		
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