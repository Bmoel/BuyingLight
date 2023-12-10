extends Node2D

onready var exitButton = $Exit;
onready var lightHolder = $LightHolder;

const GAME_PATH: String = "res://scenes/room.tscn";

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	if OS.get_name() == "HTML5":
		exitButton.queue_free();
	var lightTimer = Timer.new();
	add_child(lightTimer);
	lightTimer.wait_time = 2;
	lightTimer.one_shot = false;
	lightTimer.connect("timeout",self, "_lightTimer_expired");
	lightTimer.start();
	$buttonGroup/Play.grab_focus();

func _on_Play_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene(GAME_PATH);

func _on_Options_pressed():
	lightHolder.hide();
	$OptionsWindow.popup_centered();

func _on_Credits_pressed():
	lightHolder.hide();
	$CreditsWindow.popup_centered();

func _on_Exit_pressed():
	get_tree().quit();

func _lightTimer_expired():
	var pos: Vector2 = Vector2(randi() % 1920, randi() % 1080);
	if isInvliadPosition(pos):
		var validPositions = [
			Vector2(300, 200),
			Vector2(400, 750),
			Vector2(1000, 250),
			Vector2(1600, 400),
			Vector2(1700, 900),
		];
		var idx = randi() % 5;
		if idx > -1 and idx < 5:
			pos = validPositions[idx];
	var light = Light2D.new();
	light.texture = load("res://assets/light.webp");
	light.energy = 2;
	light.texture_scale = 0;
	light.position = pos;
	lightHolder.add_child(light);
	recursiveLightHandler(0, true, light);

func recursiveLightHandler(textureScale, isScalingUp, light):
	if textureScale < 0.2 and !isScalingUp:
		light.queue_free();
		return;
	textureScale += (0.1 if isScalingUp else -0.1);
	light.texture_scale = textureScale;
	if textureScale >= 1.5:
		isScalingUp = false;
	var delayTimer: Timer = Timer.new();
	add_child(delayTimer);
	delayTimer.wait_time = 0.1;
	delayTimer.one_shot = true;
	# warning-ignore:return_value_discarded
	delayTimer.connect("timeout",self, "_delayTimer_expired", [textureScale, isScalingUp, light, delayTimer]);
	delayTimer.start();

func _delayTimer_expired(textureScale, isScalingUp, light, delayTimer):
	delayTimer.queue_free();
	recursiveLightHandler(textureScale, isScalingUp, light);

func isInvliadPosition(pos: Vector2):
	return (pos.x > 590 and pos.x < 1395) and (pos.y > 450);

func _on_CreditsWindow_popup_hide():
	lightHolder.show();

func _on_OptionsWindow_popup_hide():
	lightHolder.show();
