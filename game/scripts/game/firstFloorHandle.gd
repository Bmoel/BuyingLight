extends Node2D

var listenForEnter: bool = false;

signal startGame;
signal showInstructions(value);

func _input(_event):
	if Input.is_action_just_pressed("ui_accept") and listenForEnter:
		emit_signal("startGame");

func _on_isntr_body_entered(_body):
	emit_signal("showInstructions", true);

func _on_isntr_body_exited(_body):
	emit_signal("showInstructions", false);

func _on_start_body_entered(_body):
	listenForEnter = true;

func _on_start_body_exited(_body):
	listenForEnter = false;
