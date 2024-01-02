extends Node2D

signal playerExited();

func _ready() -> void:
	$exitInstructions.hide();
	set_process_input(false);

func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("playerExited");

func _on_Area2D_body_entered(_body) -> void:
	$exitInstructions.show();
	set_process_input(true);

func _on_Area2D_body_exited(_body) -> void:
	$exitInstructions.hide();
	set_process_input(false);
