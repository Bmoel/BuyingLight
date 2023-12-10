extends Node2D

onready var character = $Character;
onready var minimap = $CanvasLayer/minimap;

# Called when the node enters the scene tree for the first time.
func _ready():
	character.connect("playerMoved", self, "_playerMoved");

func _playerMoved(newPosition):
	minimap.playerMoved(newPosition);
