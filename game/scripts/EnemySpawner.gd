extends Node2D

onready var basicTimer: Timer = $basicEnemySpawner;

const BASIC_ENEMY_PATH: String = "res://scenes/basicEnemy.tscn";

const basicEnemy = preload(BASIC_ENEMY_PATH);

signal spawnEnemy(newEnemy);

func initiate() -> void:
	startBasicEnemyTimer(4.0);

func startBasicEnemyTimer(time: float):
	basicTimer.one_shot = false;
	basicTimer.wait_time = time;
	basicTimer.start();

func stopBasicTimer():
	basicTimer.stop();

func _on_basicEnemySpawner_timeout():
	var newEnemy = basicEnemy.instance();
	emit_signal("spawnEnemy", newEnemy);
