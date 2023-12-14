extends Node2D

onready var character = $Character;
onready var minimap = $CanvasLayer/minimap;
onready var shop = $CanvasLayer/shop;
onready var information = $CanvasLayer/Information;

const oneHeroInstructions: String = """Hide shop: [color=#03f0fc]Tab[/color]
----------------
Total [color=#e6c829]G[/color]: """;

const twoHeroInstructions: String = """Hide shop: [color=#03f0fc]Tab[/color]
Swap Hero: [color=#edc02d]Shift[/color]
----------------
Total [color=#e6c829]G[/color]: """;

signal playerMovedUI(newPosition);
signal boughtRevealUI();

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/Information.bbcode_text = getInstructions();
	character.connect("playerMoved", self, "_playerMoved");
	shop.connect("boughtReveal", self, "_revealWasBought");

func _process(_delta):
	controlGoldCount();

func _input(_event):
	if Input.is_action_just_pressed("ui_focus_next"):
		shop.visible = !shop.visible;
		information.visible = !information.visible;

func controlGoldCount() -> void:
	$CanvasLayer/Information.bbcode_text = getInstructions() + str(Global.getCurrentGold());

func getInstructions() -> String:
	if (Global.getNumberHeroesUnlocked() > 1):
		return twoHeroInstructions;
	else:
		return oneHeroInstructions;

func setMinimapPartitions(partition: int) -> void:
	minimap.setPartitions(partition);

func revealMinimapPartition(idx: int) -> void:
	minimap.revealPartition(idx);

func _playerMoved(newPosition):
	emit_signal("playerMovedUI", newPosition);
	minimap.playerMoved(newPosition);

func _revealWasBought():
	emit_signal("boughtRevealUI");
