extends Node

var x_data = []
var y_data = []

func _slope(x:Array,y:Array):
	var xy = []
	for i in range(len(x)):
		xy.append(x[i]*y[i])
	var S_xy = _arraySum(xy) 
	
	var x2 = []
	for i in x:
		x2.append(i*i)
	var S_x2 = _arraySum(x2)
	
	return(S_xy - (len(x)*_arrayAvg(x)*_arrayAvg(y))) / (S_x2-(len(x)*_arrayAvg(x)*_arrayAvg(x)))
	
func _y_intercept(x:Array,y:Array):
	return (_arrayAvg(y)-(_slope(x,y)*_arrayAvg(x)))
	
func _arraySum(a:Array):
	var sum:float = 0.0
	for i in a:
		sum += i
	return sum

func _arrayAvg(a:Array):
	return (_arraySum(a)/len(a))
	
func predict(p):
	return _y_intercept(x_data,y_data) + (_slope(x_data,y_data)*p)
	
func optionPredict(index : int):
	var s = round(x_data[len(x_data)-1])
	var xp : Array =[]
	for i in range(index+1):
		xp.append(s+i)
	print("xp",xp)
	var predicted : Array =[]
	
	for i in xp:
		predicted.append(predict(i))
	
	return predicted
	
func fit(x:Array,y:Array):	
		x_data = x
		y_data = y
	
func addNoise(n:Array):
	var noised = []
	for i in n:
		noised.append(i + (RNGTools.randi_range(-1,1)))
	return noised

# MAE
func mae(y_hat,y,n):
	for i in range(len(y)):
		y_hat[i] = abs(y[i]-y_hat[i])
	return _arraySum(y_hat)/n
	

# MSE
func mse(y_hat,y,n):
	for i in range(len(y)):
		y_hat[i] = pow((y[i]-y_hat[i]),2)
	return _arraySum(y_hat)/n

# MAPE
