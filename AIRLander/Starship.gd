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


func _init(r,v,gamma,alpha = 0.0, w = 0.0, theta = 0.0):
	self.r = r
	self.v = v
	# self.rglobal
	# self.vglobal
	# self.gammaglobal
	# self.vlocal
	# self.gammalocal
	self.gamma = gamma #aceleracion
	self.alpha = alpha #acc angular
	self.w = w #vel angular
	self.theta = theta #ángulo
	
	
	
	#Modelo Cilíndrico, CG en el centro Geométrico (0,0) en coord locales
	self.diametro = 9.0 #diámetro
	self.radio = self.diametro/2.0 #radio
	self.h = 50 #Longitud del cohete
	
	self.m = 120000
	
	#Tensor de inercia de un cilindro (Cambiar cuando cambie el modelo a uno más realista)
	self.Itensor = Basis()
	self.Itensor.x = (self.m/12.0)*Vector3(3*pow(self.radio,2) + self.h, 0, 0)
	self.Itensor.y = (self.m/12.0)*Vector3(0,3*pow(self.radio,2) + self.h, 0)
	self.Itensor.z = (self.m/12.0)*Vector3(0, 0, 6*pow(self.radio,2))
	print(Itensor)
	self.I2D = self.Itensor.x.x #El valor que vamos a usar en el problema 2D, es la única dirección en la que lo giraremos
#	print(self.I2D)
	self.beta = 0 #Ángulo de la tobera del motor respecto al eje longitudinal
	self.Ftmax = 6000000  #Máximo empuje del motor cohete
	
	#RCS -- en el extremo superior, apuntando a -x y +x
	self.Frcs = [Vector2(-0.01,0),Vector2(0.01,0)] #Vectores de empuje del control de actitud (RCS)
	self.RCS = [1,0] #indica qué RCS están activos (1) e inactivos (0)
	self.d_rcs = self.h/2 #distancia de los rcs respecto al CG (h/2---- extremo superior del cohete)
	
	
	self.fuerzas = [] #Aquí entrarán las fuerzas en cada momento para iterar en ellas
	self.ri = [] #Brazos de las fuerzas respecto al CM (para calcular los momentos)
	self.Dt = 0.1 #Paso de tiempo en segundos
	
	var Sfuerzas = Vector2(0.0,0.0)

func update():
	#TODO: aplicar fuerzas, cambiar acc, 
	
	#clear f
	self.fuerzas = []
	self.ri = []
	self.applyThrust(self.beta)
	self.applyRCS()
	self.applyG()
	#print('ri:', self.ri)
	
	
	#Newton
	var Sfuerzas = Vector2(0.0,0.0)
	for f in fuerzas:
		Sfuerzas += f
	
	print(Sfuerzas)
	self.gamma = (1/self.m)*Sfuerzas
	#print("gamma",self.gamma)
	
	#Momentos
	self.alpha = 0
	for i in range(len(self.fuerzas)):
#		print(ri[i],fuerzas[i])
		self.alpha += ri[i].cross(fuerzas[i]) #
#		print("Cross")
#		print(ri[i].cross(fuerzas[i]))
	#velocidad
	self.v += self.gamma*self.Dt
	#posicion
	self.r += self.v *self.Dt
	
	#vel. angular
	self.w += self.alpha *self.Dt
	#angulo theta
	self.theta += self.w*self.Dt
	
	
	self.alpha *= (1/self.I2D)
	
	
	
func applyThrust(beta):
    var f = Vector2(-self.Ftmax*sin(beta), self.Ftmax*cos(beta))
    self.fuerzas.append(f)
    var brazo = Vector2(sin(beta)*cos(beta)*self.h/2.0, sin(beta)*sin(beta)*self.h/2.0)
    self.ri.append(brazo)

func applyRCS():
	for i in range(len(RCS)):
		if RCS[i]:
			self.fuerzas.append(self.Frcs[i])
			self.ri.append(Vector2(0,self.d_rcs))
    
func applyG():
	
	fuerzas.append(m*Vector2(0,-10))
	ri.append(Vector2(0.0,0.0))

func magnitud2D(vector:Vector2):
	return sqrt(vector[0]*vector[0] + vector.y*vector.y)