





#Metodos de reproduccion
#binary methods
func uniformCrossover(genes1,genes2):
    var probabilidad
    var genesHijo1 = []
    var genesHijo2 = []
    randomize()
    for i in range(len(genes1)):
        probabilidad = rand_range(0,1)
        if probabilidad > 0.5:
            genesHijo1.append(genes1[i])
            genesHijo2.append(genes2[i])
        else:
            genesHijo1.append(genes2[i])
            genesHijo2.append(genes1[i])
    

#blending methods
#TODO: sacar 2 hijos
func heuristicCrossover(genes1,genes2):
    var b
    var hijos = [[],[]]
    
    var nuevoGen
    
    #generar genes
    
    randomize()
    for i in range(len(genes1)):
        b = rand_range(0,1)
        nuevoGen = b*(genes1[i] - genes2[i]) + genes1[i]
        hijos[0].append(nuevoGen)
        nuevoGen = (1-b)*(genes1[i] - genes2[i]) + genes1[i]
        hijos[1].append(nuevoGen)
    #TODO comprobar que todos -LIMITE<gen<LIMITE
    return hijos


func calcularFit(starship):
    var fit = 0
    var distancia
    var velocidad2
    var vAngular
    var verticalidad

    distancia = starship.r.length()
    velocidad2 = starship.v.length_squared()
    verticalidad = starship.theta
    vAngular = starship.w
    fit = distancia/10.0 + velocidad2 + pow((verticalidad/5),2) + vAngular
    return fit

