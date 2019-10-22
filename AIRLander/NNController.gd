extends Reference

class_name NNController
var N = load("res://Neuron.gd")

var layersSize
var inputSize = 9 #r(2D),v(2D),gamma(2D),theta(1),w(1),alpha(1)
var hiddenLayer = []
var hiddenSize = 12
var outputLayer = []
var outputSize = 4 #RCS1,RCS2,Thrust, beta
#var neurons

# func _init():
    
#     layerSize = layerSize
func _ready():
    print("hey")    
          
func configure():
    var n
    var w
    var weights = []
    # for i in len(layerSize):
    #     neurons.append([])
    #     for j in range(layerSize[i]):
    #         n = Neuron(layerSize[i]) 
    #         neurons[i].append(n)
    for i in range(hiddenSize):
        for i in range(inputSize):
            w = rand_range(-1,1)
            weights.append(w) 
        n = N.new(w,1,"tanh")
        hiddenLayer.append(n)
    
    for i in range(outputSize):
        for i in range(hiddenSize):
            w = rand_range(-1,1)
            weights.append(w) 
        n = N.new(w,1,"tanh")
        print("hola")
    


    

# func _init():
#     print("N Creada")
#     print(N)

    
    

