extends Reference

#Output:
#RCS1 - 1 - 0
#RCS2 - 1 - 0
#Thrust - 0-FTmax
#beta - -betamin - betamax
#


class_name NeuralNetwork

var m = load("res://Matrix.gd").new()

#Matrices Cálculo red neuronal

var listaLayers = [9,12,10,12,4] #9 entradas, 3 capas intermedias (de 12,10 y 12 nodos) y 4 salidas
var list_w = []
var list_b = []
func configure(weights,biases):
    for i in range(len(listaLayers) - 1):
        list_w.append(weights[i])
        list_b.append(biases[i])

func configureG(genes):
    #numero de genes: 434
    var geneIndex = 0
    var auxW = []
    var auxB = []
    var nIn
    var nOut
    for i in range(len(listaLayers)-1):
        nIn = listaLayers[i]
        nOut = listaLayers[i+1]
        auxW = []
        for j in range(nOut):
            auxW.append([])
            for k in range(nIn):
                auxW[j].append(genes[geneIndex])
                geneIndex += 1
        list_w.append(auxW)
        auxB = []
        for j in range(nOut):
            auxB.append(genes[geneIndex])
            geneIndex += 1
        list_b.append(auxB)


func feedForward(entrada):
    var input = entrada
    var output
    for i in range(len(list_w)):
        #r = W*input + bias
        output = m.multiply_mv(list_w[i],input)
        output = m.sum_vector(output,list_b[i])
        #activacion output
        for j in range(len(output)):
            output[j] = tanh(output[j])
        #preparado para la siguiente 
        input = output
    
    #print(output)
    if input[0] < 0:
        output[0] = 0
    else:
        output[0] = 1
    
    if input[1] < 0:
        output[1] = 0
    else:
        output[1] = 1
    #print(output)
    # output[2] = tanh(input[2])
    # #print(output[2])
    output[2] = range_lerp(output[2],-1.0,1.0,0.0,100000.0)
    # #print(output[2])
    # output[3] = tanh(auxV[3])
    # #print(output[3])
    #output[3] = range_lerp(output[3],-1,1,-2,2)
    #print(auxV[3])
    print(output)
    return output