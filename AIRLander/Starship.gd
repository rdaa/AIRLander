extends Spatial

class_name Starship


var r :Vector2
var v :Vector2
var gamma :Vector2
var alpha :float
var w :float
var theta :float
var diametro :float
var radio :float
var h :float
var m :float
var Itensor 
var I2D
var beta
var Ftmax 
var Frcs 
var RCS
var d_rcs
var fuerzas
var ri
var Dt
var g
var Q

onready var ss = preload("res://Starship.tscn").instance()
onready var perceptron = load("res://Neuron.gd")
onready var NN = load("res://NNController.gd")
var perceptron1
var ssrot
var sslin
var NN1





func _init(r ,v,gamma,alpha = 0.0, w = 0.0, theta = 0.0):
	
	#ss = ss_scene.instance()
	
	
	r = r
	v = v
	# rglobal
	# vglobal
	# gammaglobal
	# vlocal
	# gammalocal
	gamma = gamma #aceleracion
	alpha = alpha #acc angular
	w = w #vel angular
	theta = theta #ángulo
	
	
	
	
	#Modelo Cilíndrico, CG en el centro Geométrico (0,0) en coord locales
	diametro = 9.0 #diámetro
	radio = diametro/2.0 #radio
	h = 50 #Longitud del cohete
	
	m = 100000
	
	#Tensor de inercia de un cilindro (Cambiar cuando cambie el modelo a uno más realista)
	Itensor = Basis()
	Itensor.x = (m/12.0)*Vector3(3*pow(radio,2) + h, 0, 0)
	Itensor.y = (m/12.0)*Vector3(0,3*pow(radio,2) + h, 0)
	Itensor.z = (m/12.0)*Vector3(0, 0, 6*pow(radio,2))
	print(Itensor)
	I2D = Itensor.x.x #El valor que vamos a usar en el problema 2D, es la única dirección en la que lo giraremos
#	print(I2D)
	beta = 0.7 #Ángulo de la tobera del motor respecto al eje longitudinal
	Ftmax = 1000000  #Máximo empuje del motor cohete
	g = 10
	
	#RCS -- en el extremo superior, apuntando a -x y +x
	Frcs = [Vector2(-15000,0),Vector2(15000,0)] #Vectores de empuje del control de actitud (RCS)
	RCS = [0,0] #indica qué RCS están activos (1) e inactivos (0)
	d_rcs = h/2 #distancia de los rcs respecto al CG (h/2---- extremo superior del cohete)
	
	
	fuerzas = [] #Aquí entrarán las fuerzas en cada momento para iterar en ellas
	ri = [] #Brazos de las fuerzas respecto al CM (para calcular los momentos)
	Dt = 0.1 #Paso de tiempo en segundos
	
	Q = []


	var Sfuerzas = Vector2(0.0,0.0)
	
	
	
func _ready():
	add_child(ss)
	ssrot = get_node("Starship/Starship-rotation")
	sslin = get_node("Starship/Starship-rotation/Starship-linear")
	sslin.set_translation(Vector3(r.x,r.y,0))
	var perceptron1 = perceptron.new([-0.5,-0.5],0)
	print("perceptron")
	print(perceptron1.compute([0.5,1]))
	#NN1 = NN.new()
	#NN1.configure()
	#procesarNN()
	r = Vector2(0.0,300.0)
	v = Vector2(0.0,0.0) 
	#ssrot.rotation.z  = deg2rad(theta)

func update():
	#TODO: aplicar fuerzas, cambiar acc, 
	#procesarNN()
	beta = 0
	if Input.is_action_pressed("ui_right"):
		beta = -1.0
	if Input.is_action_pressed("ui_left"):
		beta = 1.0
	#clear f
	fuerzas = []
	ri = []
	applyThrust(beta)
	applyRCS()
	applyG()
	#print('ri:', ri)
	
	
	#Newton
	var Sfuerzas = Vector2(0.0,0.0)
	#print(fuerzas)
	for f in fuerzas:
		Sfuerzas += f
		
	#print(Sfuerzas)
	
	#print(Sfuerzas)
	gamma = (1/m)*Sfuerzas
	#print("gamma",gamma)
	
	#Momentos
	alpha = 0
	#print(ri)
	for i in range(len(fuerzas)):
#		print(ri[i],fuerzas[i])
		alpha += ri[i].cross(fuerzas[i]) #
#		print("Cross")
#		print(ri[i].cross(fuerzas[i]))


	alpha /= I2D
	#velocidad
	v += gamma*Dt
	#posicion
	r += v *Dt
	
	#vel. angular
	w += alpha *Dt
	#angulo theta
	theta += w*Dt
	#print(theta)
	
	applyUpdate()

	
	
func calcularQ():
	var matriz = []
	matriz.append([cos(deg2rad(theta)), -sin(deg2rad(theta))])
	matriz.append([sin(deg2rad(theta)), cos(deg2rad(theta))])
	return matriz

func applyThrust(beta):
	var betarad = deg2rad(beta)
	var f = Vector2(-Ftmax*sin(betarad), Ftmax*cos(betarad))
	fuerzas.append(f)
	#print(f)
	var brazo = Vector2(sin(betarad)*cos(betarad)*h/2.0, -sin(betarad)*sin(betarad)*h/2.0)
	ri.append(brazo)

func applyRCS():
	for i in range(len(RCS)):
		if RCS[i]:
			fuerzas.append(Frcs[i])
			ri.append(Vector2(0,d_rcs))
    
func applyG():
	var fg = m*g*Vector2(sin(deg2rad(theta)),-cos(deg2rad(theta)))
	fuerzas.append(fg)
	#print(fg)
	ri.append(Vector2(0.0,0.0))


func applyUpdate():
	#print('rot',ssrotational)
	sslin.set_translation(Vector3(r.x,r.y,0))
	#ssrot.rotate(Vector3(0,0,1),deg2rad(w))
	ssrot.rotation.z  = deg2rad(theta)
	

func crear():
	add_child(ss)
	ssrot = get_node("Starship/Starship-rotation")
	sslin = get_node("Starship/Starship-rotation/Starship-linear")
	sslin.set_translation(Vector3(r.x,r.y,0))
	#ssrot.rotation.z  = deg2rad(theta)
	

func procesarNN():
	var inputNN = []
	var output = []
	#print(r)
	for i in range(2):
		inputNN.append(r[i]/1000.0)
	for i in range(2):
		inputNN.append(v[i]/100.0)
	for i in range(2):
		inputNN.append(gamma[i]/10.0)
	
	inputNN.append(theta/360.0)
	inputNN.append(w/10.0)
	inputNN.append(alpha/10.0)

	#print(inputNN)
	output = NN1.feedForward(inputNN)
	RCS = [output[0], output[1]]
	Ftmax = output[2]
	beta = output[3]