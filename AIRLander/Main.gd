extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var s = load("res://Starship.gd")

onready var Starship_scene = preload("res://Starship.tscn")

var pos = Vector2(200.0,10.0)
var vel = Vector2(0.0,200.0)
var gamma = Vector2(0.0,0.0)
var theta = 90
var s1
var ss
#var s2 = s.new(Vector2(50.0,30.0),vel,gamma)


# Called when the node enters the scene tree for the first time.
func _ready():
	
	s1 = s.new(pos,vel,gamma)
	s1.name = "hola"
	add_child(s1)
	#s1.crear()
	s1.update()
	#ss = Starship_scene.instance()
	#add_child(ss)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	s1.update()
	#print(nuevas.r,nuevas.theta)
