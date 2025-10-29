extends Node

var game_over_scene_path = "res://scenes/game_over.tscn"
var win_scene_path = "res://scenes/win.tscn"
var main_level_path = "res://scenes/ruinas_de_acero.tscn"

func game_over():
	print("El juego ha termiado, has perdido!")
	get_tree().paused = true
	get_tree().change_scene_to_file(game_over_scene_path)
func restart_game():
	get_tree().paused = false	
	get_tree().change_scene_to_file(main_level_path)

func Win():
	print("Felicidades! Has ganado.")
	get_tree().paused = true	
	get_tree().change_scene_to_file(win_scene_path)
	

	
