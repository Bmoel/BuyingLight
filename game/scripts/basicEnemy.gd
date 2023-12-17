extends KinematicBody2D

var _playerPosition: Vector2 = Vector2.ZERO;
var _obfuscatedPosition: Vector2 = Vector2.ZERO;
var _justHit: int = 4;
var _isDead: bool = false;
var _goldAmount = 1;
var _damageToDeal: int = 10;

var velocity: Vector2 = Vector2.ZERO;
var baseSpeed:int = 300;
var baseHealth:int = 10;

var room = null;

var blinkTmr: float = 0.0;
var obfuscaterTimer: float = TIME_BTWN_OBFUSCATING;

const NUM_BLINKS: int = 4;
const TIME_BTWN_BLINKS: float = 0.25;
const TIME_BTWN_OBFUSCATING: float = 1.5;

func _ready():
	randomize();
	$AnimatedSprite.play("default");

func _process(delta):
	if room == null:
		return;
	obfuscaterTimer += delta;
	if obfuscaterTimer >= TIME_BTWN_OBFUSCATING:
		_obfuscatedPosition = _playerPosition + Vector2(
			_playerPosition.x + rand_range(-500.0, 500.0),
			_playerPosition.y + rand_range(-500.0, 500.0)
		);
		obfuscaterTimer = 0.0;
	velocity = position.direction_to(_playerPosition) * baseSpeed;
	velocity = move_and_slide(velocity);
	blinkTmr += delta;
	if _justHit < NUM_BLINKS and blinkTmr > TIME_BTWN_BLINKS:
		blinkTmr = 0.0;
		visible = !visible;
		_justHit += 1;
	elif _justHit >= NUM_BLINKS:
		blinkTmr = 0.0;

func setRoom(newRoom) -> void:
	room = newRoom;
	room.connect("playerMovedRoom", self, "_playerMoved");

func takeDamage(dmgAmount: int) -> void:
	baseHealth -= dmgAmount;
	$enemyHit.play();
	if baseHealth <= 0:
		_isDead = true;
		self.hide();
		Global.addToCurrentGold(_goldAmount);
		return;
	_justHit = 0;

func getDamageAmount() -> int:
	return _damageToDeal;

func death() -> void:
	queue_free();

func _playerMoved(newPosition) -> void:
	_playerPosition = newPosition;

func _on_enemyHit_finished():
	if _isDead:
		queue_free();
