extends Node2D

onready var dashCDTimer = $Container/DashCD/Timer;
onready var dashText = $Container/DashCD;
onready var healthbar = $Container/healthBar;

var hasUnlimitedDashes: bool = false;

signal playerDied();

func _ready():
	# warning-ignore:return_value_discarded
	CharacterUpgrades.connect("healPlayer", self, "_healCharacter");
	# warning-ignore:return_value_discarded
	CharacterUpgrades.connect("dashChange", self, "_handleDashChange");
	hasUnlimitedDashes = Global.hasUnlimitedDashes;
	healthbar.value = Global.playerHealth;

func _process(_delta):
	if !dashCDTimer.is_stopped():
		var time: float = stepify(dashCDTimer.time_left, 0.01);
		dashText.text = "Dash: " + str(time) + 's';

func startTimer(amountOfTime: float) -> void:
	if hasUnlimitedDashes:
		return;
	dashCDTimer.start(amountOfTime);

func handleDamageTaken(dmg: int) -> void:
	var newHealthValue: int = healthbar.value - dmg;
	if newHealthValue <= 0:
		emit_signal("playerDied");
	healthbar.value = newHealthValue;

func _on_Timer_timeout():
	dashCDTimer.stop();
	dashText.text = "Dash: Ready";

func _healCharacter(healthToAdd: int) -> void:
	healthbar.value += healthToAdd;

func _handleDashChange(value: int) -> void:
	if value == 0:
		hasUnlimitedDashes = true;
		dashCDTimer.stop();
		dashText.text = "Dash: UNLIMITED";
		return;
	if ((dashCDTimer.wait_time - value) <= 0):
		return;
	dashCDTimer.wait_time -= value;
