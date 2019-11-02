extends Reference

#Output:
#RCS1 - 1 - 0
#RCS2 - 1 - 0
#Thrust - 0-FTmax
#beta - -betamin - betamax
#


class_name NNController
var N = load("res://Neuron.gd")
var m = load("res://Matrix.gd").new()

#Matrices Cálculo red neuronal
#Estructura red neuronal: 9 inputs, 12 neuronas hidden, 4 output
#Matrices pesos
var W1
var W2
#Vectores bias
var B1
var B2

#Vectores inputs (input y salida hidden)
var I1
var I2

var output


var layersSize
var inputLayer = []
var inputSize = 9 #r(2D),v(2D),gamma(2D),theta(1),w(1),alpha(1)
var hiddenLayer = []
var hiddenSize = 12
var outputLayer = []
var outputSize = 4 #RCS1,RCS2,Thrust, beta
var matriz = []

#var neurons

# func _init():
    
#     layerSize = layerSize
  
          
func configure():
    var n
    var w
    var weights = []

    W1 = m.zero_matrix(hiddenSize,inputSize)
    B1 = m.ones_vector(hiddenSize)
    W2 = m.zero_matrix(outputSize,hiddenSize)
    B2 = m.ones_vector(outputSize)
    I1 = m.zero_vector(inputSize)
    I2 = m.zero_vector(hiddenSize)
    output = m.zero_vector(outputSize)

    for i in range(hiddenSize):
        for j in range(inputSize):
            W1[i][j] = rand_range(-1,1)
        B1[i] = rand_range(-1,1)
    
    for i in range(outputSize):
        for j in range(hiddenSize):
            W2[i][j] = rand_range(-1,1)
        B2[i] = rand_range(-1,1)
    
    

func feedForward(entrada):
    var aux_vector
    var auxV
    #print(entrada)
    I1 = entrada
    auxV = m.multiply_mv(W1,I1)
    
    auxV = m.sum_vector(auxV,B1)
    for i in range(len(auxV)):
        I2[i] = tanh(auxV[i])
    
    auxV = m.multiply_mv(W2,I2)
    
    auxV = m.sum_vector(auxV,B2)
    
    if auxV[0] < 0:
        output[0] = 0
    else:
        output[0] = 1
    
    if auxV[1] < 0:
        output[1] = 0
    else:
        output[1] = 1
    #print(output)
    output[2] = tanh(auxV[2])
    #print(output[2])
    output[2] = range_lerp(output[2],-1.0,1.0,0.0,10000000.0)
    #print(output[2])
    output[3] = tanh(auxV[3])
    #print(output[3])
    output[3] = range_lerp(output[3],-1,1,-2,2)
    #print(auxV[3])
    
    return(output)
    
    
    

# func _init():
#     print("N Creada")
#     print(N)

    
    

