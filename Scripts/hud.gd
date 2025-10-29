extends CanvasLayer


# Called when the node enters the scene tree for the first time.
@onready var heart_bar = $heart_bar
@onready var timer = $Timer
@onready var label = $TimerLabel

#definimos el timer
func _ready():
	label.text = format_time(timer.wait_time)
	timer.start()

func _process(_delta):
	if timer.time_left > 0:
		label.text = format_time(timer.time_left)
	else:
		label.text = "0:00"
		print("Perdiste, se acabo el tiempo!")
		GameState.game_over()


func format_time(time_left: float) -> String:
	var total_seconds = int(time_left)
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	return str(minutes) + ":" + str(seconds).pad_zeros(2)
	
func actualizar_corazones(current_health, max_health):
	heart_bar.frame = max_health - current_health
