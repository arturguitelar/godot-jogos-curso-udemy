extends Node2D

const JOGANDO = 1
const PERDENDO = 2

var pontos = 0
var estado = JOGANDO

onready var felpudo = get_node('Felpudo')
onready var back_anim = get_node('BackAnim')
onready var time_replay = get_node('TimeToReplay')
onready var label = get_node('Node2D/Control/Label')
onready var som_score = get_node('Sons/SomScore')
onready var som_hit = get_node('Sons/SomHit')

func _ready():
	pass

func kill():
	felpudo.apply_impulse(Vector2(0,0), Vector2(-1000, 0))
	back_anim.stop()
	estado = PERDENDO
	som_hit.play()
	time_replay.start()
	
func pontuar():
	pontos += 1
	label.set_text(str(pontos))
	som_score.play()

func _on_TimeToReplay_timeout():
	get_tree().reload_current_scene()
