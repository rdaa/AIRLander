extends Reference

var w 
var b 
var activationMode

func _init(weights, bias = 0.1,activationMode = "tanh"):
    w = weights
    b = bias
    activationMode = activationMode
    
func compute(var inputs):
    var r
    r = b
    for i in range(len(inputs)):
        r += inputs[i] * w[i]
    if activationMode == "tanh":
        return(activate_tanh(r))
    elif activationMode == "sign":
        return(activate_sign(r))

func activate_sign(r):
    
    if r < 0:
        return -1
    else:
        return 1

func activate_tanh(r):
    return tanh(r)




