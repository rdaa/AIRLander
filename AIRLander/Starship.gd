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
onready var ss = preload("res://Starship.tscn").instance()
var ssrot





func _init(r,v,gamma,alpha = 0.0, w = 0.0, theta = 0.0):
	
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
	
	m = 120000
	
	#Tensor de inercia de un cilindro (Cambiar cuando cambie el modelo a uno más realista)
	Itensor = Basis()
	Itensor.x = (m/12.0)*Vector3(3*pow(radio,2) + h, 0, 0)
	Itensor.y = (m/12.0)*Vector3(0,3*pow(radio,2) + h, 0)
	Itensor.z = (m/12.0)*Vector3(0, 0, 6*pow(radio,2))
	print(Itensor)
	I2D = Itensor.x.x #El valor que vamos a usar en el problema 2D, es la única dirección en la que lo giraremos
#	print(I2D)
	beta = 0 #Ángulo de la tobera del motor respecto al eje longitudinal
	Ftmax = 1200000  #Máximo empuje del motor cohete
	
	#RCS -- en el extremo superior, apuntando a -x y +x
	Frcs = [Vector2(-0.01,0),Vector2(0.01,0)] #Vectores de empuje del control de actitud (RCS)
	RCS = [1,0] #indica qué RCS están activos (1) e inactivos (0)
	d_rcs = h/2 #distancia de los rcs respecto al CG (h/2---- extremo superior del cohete)
	
	
	fuerzas = [] #Aquí entrarán las fuerzas en cada momento para iterar en ellas
	ri = [] #Brazos de las fuerzas respecto al CM (para calcular los momentos)
	Dt = 0.1 #Paso de tiempo en segundos
	
	var Sfuerzas = Vector2(0.0,0.0)
	
	

func update():
	#TODO: aplicar fuerzas, cambiar acc, 
	
	#clear f
	fuerzas = []
	ri = []
	applyThrust(beta)
	applyRCS()
	applyG()
	#print('ri:', ri)
	
	
	#Newton
	var Sfuerzas = Vector2(0.0,0.0)
	for f in fuerzas:
		Sfuerzas += f
	
	#print(Sfuerzas)
	gamma = (1/m)*Sfuerzas
	#print("gamma",gamma)
	
	#Momentos
	alpha = 0
	for i in range(len(fuerzas)):
#		print(ri[i],fuerzas[i])
		alpha += ri[i].cross(fuerzas[i]) #
#		print("Cross")
#		print(ri[i].cross(fuerzas[i]))
	#velocidad
	v += gamma*Dt
	#posicion
	r += v *Dt
	
	#vel. angular
	w += alpha *Dt
	#angulo theta
	theta += w*Dt
	alpha *= (1/I2D)
	applyUpdate()

	
	
	
func applyThrust(beta):
    var f = Vector2(-Ftmax*sin(beta), Ftmax*cos(beta))
    fuerzas.append(f)
    var brazo = Vector2(sin(beta)*cos(beta)*h/2.0, sin(beta)*sin(beta)*h/2.0)
    ri.append(brazo)

func applyRCS():
	for i in range(len(RCS)):
		if RCS[i]:
			fuerzas.append(Frcs[i])
			ri.append(Vector2(0,d_rcs))
    
func applyG():
	
	fuerzas.append(m*Vector2(0,-10))
	ri.append(Vector2(0.0,0.0))


func applyUpdate():
	#print('rot',ssrotational)
	ss.set_translation(Vector3(r.x,r.y,0))
	ssrot.rotate(Vector3(0,0,1),deg2rad(w))
	

func crear():
	add_child(ss)
	ssrot = get_node("Starship/Starship-rotation")
	ss.set_translation(Vector3(r.x,r.y,0))