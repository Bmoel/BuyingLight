extends Node

var atkUp: int = 0;
var defUp: int = 0;
var spdUp: int = 0;

enum Types {
	ATK,
	DEF,
	REGEN,
	SPEED,
	INVULNERABLE,
	WIPE
}

signal healPlayer(health);
signal wipeEnemies();

func initializeUpgrades() -> void:
	atkUp = 0;
	defUp = 0;
	spdUp = 0;

func applyUpgrade(details: Array) -> void:
	if typeof(details) != TYPE_ARRAY:
		return;
	if len(details) != 2:
		return;
	var type = details[0];
	var value = details[1];
	match (type):
		Types.ATK:
			increaseAtk(value);
		Types.DEF:
			increaseDef(value);
		Types.REGEN:
			pass;
		Types.SPEED:
			increaseSpeed(value);
		Types.WIPE:
			emit_signal("wipeEnemies");

func increaseAtk(value: int) -> void:
	if typeof(value) != TYPE_INT:
		return;
	atkUp += value;

func increaseDef(value: int) -> void:
	if typeof(value) != TYPE_INT:
		return;
	defUp += value;

func increaseSpeed(value: int) -> void:
	if typeof(value) != TYPE_INT:
		return;
	spdUp += value;

func regenHealth(value: int) -> void:
	if typeof(value) != TYPE_INT:
		return;
	emit_signal("healPlayer", value);
