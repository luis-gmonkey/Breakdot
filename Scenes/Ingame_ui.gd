extends CanvasLayer


func _ready():
	pass # Replace with function body.

func setNumberOfBalls(number):
	$Balls.text = "Balls:     "+str(number)
	
func setTime(time):
	$Time.text = "Time:     "+str(time)

# Reset the UI nodes to start the level again 
func resetUI():
	$Balls.show()
	$Time.show()
	$WinScreen.hide()
	
func levelCleared(time):
	$WinScreen/TimeLabel.text = "Time:  %s" %time
	$Balls.hide()
	$Time.hide()
	$WinScreen.show()
