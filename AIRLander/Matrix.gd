extends Reference

func zero_matrix(nX, nY):
    var matrix = []
    for x in range(nX):
        matrix.append([])
        for y in range(nY):
            matrix[x].append(0)
    return matrix


func multiply(a, b):
    var matrix = zero_matrix(a.size(), b[0].size())
    for i in range(a.size()):
        for j in range(b[0].size()):
            for k in range(a[0].size()):
                matrix[i][j] = matrix[i][j] + a[i][k] * b[k][j]
    return matrix

func multiply_mv(a,b):
    var vector = []
    var res
    #print("Msize:",a[0].size())
    #print("Vsize",b.size())
    for i in range(a.size()):
        res = 0
        for j in range(a[i].size()):
            res += a[i][j] * b[j]
        vector.append(res)
    return vector

func map(valor:float, istart:float, istop:float, ostart:float, ostop:float):
    return ostart + (ostop - ostart) * ((valor - istart) / (istop - istart))

func zero_vector(nX):
    var vector = []
    for x in range(nX):
        vector.append(0)
    return vector


func ones_vector(nX):
    var vector = []
    for x in range(nX):
        vector.append(1)
    return vector

func sum_vector(a,b):
    var vector = []
    for i in range(a.size()):
        vector.append(0)
        vector[i] = a[i] + b[i]
    return vector