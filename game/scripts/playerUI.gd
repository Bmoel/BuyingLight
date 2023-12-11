extends Node2D

onready var character = $Character;
onready var minimap = $CanvasLayer/minimap;
onready var shop = $CanvasLayer/shop;
onready var keybinds = $CanvasLayer/Keybinds;

# Called when the node enters the scene tree for the first time.
func _ready():
	character.connect("playerMoved", self, "_playerMoved");

func _process(_delta):
	controlGoldCount();

func _input(_event):
	if Input.is_action_just_pressed("ui_focus_next"):
		shop.visible = !shop.visible;
		keybinds.visible = !keybinds.visible;

func controlGoldCount() -> void:
	$CanvasLayer/Gold.bbcode_text = "----------------\n";
	$CanvasLayer/Gold.bbcode_text += "Total [color=#e6c829]G[/color]: ";
	$CanvasLayer/Gold.bbcode_text += str(Global.getCurrentGold());

func _playerMoved(newPosition):
	minimap.playerMoved(newPosition);
