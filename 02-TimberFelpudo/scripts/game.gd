extends Node

# Referências para as cenas dos barris
var barrel = preload("res://scenes/barrel.tscn")
var barrelLeft = preload("res://scenes/barrelLeft.tscn")
var barrelRight = preload("res://scenes/barrelRight.tscn")

onready var player = get_node("Felpudo")
onready var camera = get_node("Camera")
onready var barrelsSpawner = get_node("BarrelsSpawner")
onready var destroyBarrels = get_node("DestroyBarrels")
onready var bar = get_node("Bar")

# Referências de medida e posição utilizadas para criar e reposicionar os barris
const HALF_SCREEN = 360
const START_Y_POSITION = 1090
const BARREL_HEIGHT = 172

var lastEnemy
var barrelLeftGroup = "barrelLeftGroup"
var barrelRightGroup = "barrelRightGroup"

func _ready():
	randomize()
	set_process_input(true)
	
	# gerando barris
	initBarrels()

	# conectando um signal na barra para fazer o player
	# perder quando a barra estiver vazia.
	bar.connect("lose", self, "loseGame")

# tratando evento de toque na tela utilizando a câmera
func _input(event):
	event = camera.make_input_local(event)
	
	if (event.type == InputEvent.SCREEN_TOUCH and event.pressed):
		# se está tocando do lado esquerdo bota o player na esquerda
		if (event.pos.x < 360):
			player.toLeft()
		# caso contrário está tocando do lado direito, bota o player na direita
		else:
			player.toRight()
			
		# É preciso verificar se há um inimigo do lado em que o player irá bater.
		# Se não há, então retira-se o barril da lista de spawns e
		# adiciona-se este barril à lista de barris destruídos e o destrói.
		# Caso haja, o player perde.
		if (!hasEnemy()):
			player.hit()
			
			var first = barrelsSpawner.get_children()[0]
			barrelsSpawner.remove_child(first)
			destroyBarrels.add_child(first)
			
			first.destroyBarrel(player.side)
			
			# adiciona um novo barril
			randomizeBarrels(Vector2(HALF_SCREEN, START_Y_POSITION - 10 * BARREL_HEIGHT))

			# desce os barris
			dropBarrels()

			# adiciona um pouco de "tempo" na barra
			# 0.014 = número arbitrário para o tamanho do "gomo" que é adicionado
			bar.add(0.014)

			if (hasEnemy()):
				loseGame();
		
		else: loseGame();

# Cria um novo barril na posição indicada de acordo com o "tipo" de barril.
# tipos de barril:
# 0 - Barril normal
# 1 - Barril com inimigo para a esquerda
# 2 - Barril com inimigo para a direita
# Adiciona os barris de inimigos a um grupo.
# Seta true ou false caso o barril contenha um inimigo.
# Adiciona este barril ao spawner de barris
func createBarrel(type, pos):
	var newBarrel
	if (type == 0):
		newBarrel = barrel.instance()
		lastEnemy = false
	elif (type == 1):
		newBarrel = barrelLeft.instance()
		newBarrel.add_to_group(barrelLeftGroup)
		lastEnemy = true
	elif (type == 2):
		newBarrel = barrelRight.instance()
		newBarrel.add_to_group(barrelRightGroup)
		lastEnemy = true
	
	newBarrel.set_pos(pos)
	barrelsSpawner.add_child(newBarrel)

# Randomiza os barris
# Caso o último barril tenha sido um inimigo,
# este barril será trocado por um barril normal
# para que não haja vários inimigos seguidos.
func randomizeBarrels(pos):
	var num = rand_range(0, 3)
	if (lastEnemy): num = 0
	
	createBarrel(int(num), pos)
	
# Gera os barris iniciais em uma sequência pré-determinada
# 1090 - i * 172 = cálculo da altura onde serão gerados os barris
# i = barril atual
func initBarrels():
	# os 3 primeiros barris são normais
	for i in range(0, 3):
		createBarrel(0, Vector2(HALF_SCREEN, START_Y_POSITION - i * BARREL_HEIGHT))
	
	# a partir daqui gera barris aleatórios
	for i in range(3, 10):
		randomizeBarrels(Vector2(HALF_SCREEN, START_Y_POSITION - i * BARREL_HEIGHT))
	
# Verifica se o personagem do player colidiu com um barril onde há inimigo
func hasEnemy():
	var side = player.side
	var first = barrelsSpawner.get_children()[0]
	
	if (side == player.LEFT and first.is_in_group(barrelLeftGroup) or side == player.RIGHT and first.is_in_group(barrelRightGroup)):
		return true
	
	return false

# Desce a posição dos barris.
func dropBarrels():
	for b in barrelsSpawner.get_children():
		b.set_pos(b.get_pos() + Vector2(0, 172))

# Perde o jogo.
func loseGame():
	player.die()
	bar.set_process(false)
