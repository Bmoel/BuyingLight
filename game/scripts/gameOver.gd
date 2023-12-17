extends Node2D

const MAIN_MENU = "res://scenes/mainMenu.tscn";
const ROOM = "res://scenes/room.tscn";

func _ready():
	$Buttons/MainMenu.grab_focus();

func _on_MainMenu_pressed():
	Global.setupGame();
	# warning-ignore:return_value_discarded
	get_tree().change_scene(MAIN_MENU);

func _on_Replay_pressed():
	Global.setupGame();
	# warning-ignore:return_value_discarded
	get_tree().change_scene(ROOM);
