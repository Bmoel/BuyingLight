extends Node2D

onready var basicTimer: Timer = $basicEnemySpawner;
onready var blinkTimer: Timer = $blinkerEnemySpawner;

const BASIC_ENEMY_PATH: String = "res://scenes/basicEnemy.tscn";
const BLINK_ENEMY_PATH: String = "res://scenes/blinkingEnemy.tscn";

const basicEnemy = preload(BASIC_ENEMY_PATH);
const blinkEnemy = preload(BLINK_ENEMY_PATH);

signal spawnEnemy(newEnemy);

func initiate() -> void:
	startBasicEnemyTimer(8.0);
	startBlinkEnemyTimer(12.0);

func startBasicEnemyTimer(time: float):
	basicTimer.one_shot = false;
	basicTimer.wait_time = time;
	basicTimer.start();

func startBlinkEnemyTimer(time: float):
	blinkTimer.one_shot = false;
	blinkTimer.wait_time = time;
	blinkTimer.start();

func stopBasicTimer():
	basicTimer.stop();

func _on_basicEnemySpawner_timeout():
	var newEnemy = basicEnemy.instance();
	emit_signal("spawnEnemy", newEnemy);


func _on_blinkerEnemySpawner_timeout():
	var newEnemy = blinkEnemy.instance();
	emit_signal("spawnEnemy", newEnemy);
