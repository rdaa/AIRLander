extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var s = load("res://Starship.gd")
onready var ga = load("res://GA.gd").new(100,434)

var pos = Vector2(0.0, 1200)
var vel = Vector2(0.0,-250)
var acc = Vector2(0.0,0.0)
var s1
var ss
#GA
var popSize = 100
var pop = []
var genes = []
var tiempo = 0
var Dt = 0.05

var checkfit = false
#var s2 = s.new(Vector2(50.0,30.0),vel,gamma)


# Called when the node enters the scene tree for the first time.
func _ready():
	
	print(ga.poblacion)
	#s1 = s.new(pos,vel,gamma)
	#s1.name = "hola"
	#add_child(s1)
	#s1.crear()
	#s1.update()
	#ss = Starship_scene.instance()
	#add_child(ss)
	randomize()
	for i in range(popSize):
		ss = s.new(pos,vel,acc)
		ss.name = "Starship"+str(i)
		pop.append(ss)
		add_child(ss)	
		ss.indice = i

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if tiempo < 5:
		for starship in pop:
			starship.update()
		tiempo += Dt
	elif checkfit == false:
		
		for starship in pop:
			starship.finished = true
			print(ga.calcularFit(starship))
		checkfit = true
		

		
	#print(nuevas.r,nuevas.theta)


func _contactoSuelo(body):
	ga.calcularFit()
	
