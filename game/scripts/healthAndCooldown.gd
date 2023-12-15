extends Node2D

onready var dashCDTimer = $Container/DashCD/Timer;
onready var dashText = $Container/DashCD;

func _process(_delta):
	if !dashCDTimer.is_stopped():
		var time: float = stepify(dashCDTimer.time_left, 0.01);
		dashText.text = "Dash: " + str(time) + 's';

func startTimer(amountOfTime: float) -> void:
	dashCDTimer.start(amountOfTime);

func _on_Timer_timeout():
	dashCDTimer.stop();
	dashText.text = "Dash: Ready";
