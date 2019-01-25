extends Node

func _on_StartSingle_pressed():
	get_tree().change_scene("res://singlePlayer.tscn")


func _on_StartMulti_pressed():
	get_tree().change_scene("res://multiPlayer.tscn")
