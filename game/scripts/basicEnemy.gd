extends KinematicBody2D

var _playerPosition: Vector2 = Vector2.ZERO;
var _obfuscatedPosition: Vector2 = Vector2.ZERO;
var _justHit: int = 4;
var _isDead: bool = false;
var _goldAmount = 1;

var velocity: Vector2 = Vector2.ZERO;
var baseSpeed:int = 250;
var baseHealth:int = 10;

var room = null;

const NUM_BLINKS: int = 4;
const TIME_BTWN_BLINKS: float = 0.25;
const TIME_BTWN_OBFUSCATING: float = 1.5;

func _ready():
	randomize();

var blinkTmr: float = 0.0;
var obfuscaterTimer: float = TIME_BTWN_OBFUSCATING;
func _process(delta):
	if room == null:
		return;
	obfuscaterTimer += delta;
	if obfuscaterTimer >= TIME_BTWN_OBFUSCATING:
		_obfuscatedPosition = _playerPosition + Vector2(
			_playerPosition.x + rand_range(-300.0, 300.0),
			_playerPosition.y + rand_range(-300.0, 300.0)
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

func _playerMoved(newPosition) -> void:
	_playerPosition = newPosition;

func _on_enemyHit_finished():
	if _isDead:
		queue_free();
