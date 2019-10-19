extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var s = load("res://Starship.gd")
var pos = Vector2(10.0,10.0)
var vel = Vector2(0.0,-300.0)
var gamma = Vector2(0.0,0.0)
var nuevas = s.new(pos,vel,gamma)


# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	
	nuevas.update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	nuevas.update()
	print(nuevas.r,nuevas.theta)
