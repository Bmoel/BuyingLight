extends KinematicBody2D

onready var animationPlayer: AnimatedSprite = $Pivot/spriteFrames;
onready var characterPivot: Position2D = $Pivot;
onready var knightHurtboxPivot: Position2D = $KnightHurtboxPivot;
onready var atkIndicatorPivot: Position2D = $AtkIndicator;
onready var indicatorSprite: Sprite = $AtkIndicator/IndicatorSprite;
onready var knightSwordHitbox: CollisionShape2D = $KnightHurtboxPivot/knight/CollisionShape2D;

var currentCharacter: String = "knight";
const CHARACTER_SCALES: Dictionary = {
	"knight": Vector2(2,2),
	"archer": Vector2(3.25,3.25),
	"shotgunner": Vector2(4,4)
}

var inAttackAnimation: bool = false;

const FRICTION = 500;
const DASH_MULTIPLIER: int = 4;
var ACCELERATION = 25000;
var MAX_SPEED = 500;
var DASH_COOLDOWN = 6;

const MID_X: int = 960;
const MID_Y: int = 540;

var velocity = Vector2.ZERO;
var _dashCooldownAvalailable: bool = true;

signal playerMoved(newPosition);

# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("default");
	# warning-ignore:return_value_discarded
	animationPlayer.connect("animation_finished", self, "_animationFinished");
	knightSwordHitbox.disabled = true;

func _input(_event):
	if Input.is_action_just_pressed("change_character"):
		currentCharacter = getNextCharacter(currentCharacter);
		handleNextCharacterSpawn();
	if Input.is_action_just_pressed("character_attack") and !inAttackAnimation:
		var pivotDir: int = getDirectionFromMouse();
		knightHurtboxPivot.scale.x = pivotDir;
		characterPivot.scale.x = pivotDir;
		animationPlayer.play(currentCharacter + "_attack");
		inAttackAnimation = true;
		handleCharacterAttack();
	if Input.is_action_just_pressed("ui_select") and _dashCooldownAvalailable:
		MAX_SPEED *= DASH_MULTIPLIER;
		ACCELERATION *= DASH_MULTIPLIER;
		_dashCooldownAvalailable = false;
		var dashTimer = Timer.new();
		var dashCooldownTimer = Timer.new();
		dashTimer.one_shot = true;
		dashCooldownTimer.one_shot = true;
		dashTimer.wait_time = 0.15;
		dashCooldownTimer.wait_time = DASH_COOLDOWN;
		dashTimer.connect("timeout", self, "_on_dashSpeedTimer_timeout", [dashTimer]);
		dashCooldownTimer.connect("timeout", self, "_on_dashCooldownTimer_timeout", [dashCooldownTimer]);
		add_child(dashTimer);
		add_child(dashCooldownTimer);
		dashTimer.start();
		dashCooldownTimer.start();

var deltaTimer: float = 0;
const DELTA_MAX: float = 0.5;
func _physics_process(delta):
	emit_signal("playerMoved", position);
	var input_velocity = Vector2.ZERO;
	input_velocity.x = Input.get_axis("ui_left", "ui_right");
	input_velocity.y = Input.get_axis("ui_up", "ui_down");
	
	input_velocity = input_velocity.normalized();
	
	# Case where no input is given
	if input_velocity == Vector2.ZERO:
		velocity = input_velocity.move_toward(Vector2.ZERO, FRICTION*delta);
	# Case where only vertical input is given
	elif input_velocity.x == 0:
		velocity = input_velocity.move_toward(Vector2(0,input_velocity.y).normalized()*MAX_SPEED, ACCELERATION*delta);
	# Case where only horizontal input is given
	elif input_velocity.y == 0:
		velocity = input_velocity.move_toward(Vector2(input_velocity.x,0).normalized()*MAX_SPEED, ACCELERATION*delta);
	# Case where both horizontal and vertical input is given
	else:
		velocity = input_velocity.move_toward(0.7*input_velocity*MAX_SPEED, ACCELERATION*delta);
	
	velocity = move_and_slide(velocity);
	
	#Atk indicator direction for player
	var timeToBlink: bool = false;
	deltaTimer += delta;
	if deltaTimer > DELTA_MAX:
		deltaTimer = 0;
		timeToBlink = true;
	handleAtkIndicator(timeToBlink);
	#end region Atk indicator

	knightHurtboxPivot.scale.x = getDirectionFromMouse();
	controlAnimations(velocity);

func getNextCharacter(character: String) -> String:
	var unlockedHeroes: Array = Global.getHeroesUnlocked();
	var found: bool = false;
	for hero in unlockedHeroes:
		if hero == character and !found:
			found = true;
			continue;
		if found:
			return hero;
	if found and len(unlockedHeroes) > 0:
		return unlockedHeroes[0];
	return "knight";

func handleNextCharacterSpawn():
	var newScale: Vector2 = CHARACTER_SCALES.get(currentCharacter);
	if newScale == null:
		newScale = Vector2(2,2);
	animationPlayer.scale = newScale; 
	if currentCharacter == "shotgunner":
		animationPlayer.position = Vector2(15,-15);
	else:
		animationPlayer.position = Vector2.ZERO;

func handleCharacterAttack():
	if currentCharacter == "knight":
		handleKnightAttack();

func handleKnightAttack():
	var delayTimer = Timer.new();
	delayTimer.wait_time = 0.65;
	delayTimer.one_shot = true;
	delayTimer.connect("timeout", self, "_on_knight_delayTimer_timeout", [delayTimer]);
	add_child(delayTimer);
	delayTimer.start();

func controlAnimations(vel: Vector2):
	if inAttackAnimation:
		return;
	vel = vel.normalized();
	if vel == Vector2.ZERO:
		animationPlayer.play(currentCharacter + "_idle");
		return;
	if vel.x != 0:
		characterPivot.scale.x = 1 if (vel.x > 0) else -1;
	animationPlayer.play(currentCharacter + "_move");

func handleAtkIndicator(timeToBlink: bool) -> void:
	if timeToBlink:
		indicatorSprite.visible = !indicatorSprite.visible;
	match(currentCharacter):
		"knight": knightAtkIndicator();
		_: rangedAtkIndicator();

func knightAtkIndicator() -> void:
	atkIndicatorPivot.scale.x = getDirectionFromMouse();

func rangedAtkIndicator() -> void:
	var viewPort: Viewport = get_viewport();
	var mousePosition: Vector2 = viewPort.get_mouse_position();
	var rad = atan2(mousePosition.y,mousePosition.x);
	atkIndicatorPivot.rotation = rad;

func getDirectionFromMouse() -> int:
	var viewPort: Viewport = get_viewport();
	var dimensions: Vector2 = viewPort.size;
	var mousePosition: Vector2 = viewPort.get_mouse_position();
	return 1 if (mousePosition.x > abs(dimensions.x/2)) else -1;

func _animationFinished():
	var lastAnimation: String = animationPlayer.animation;
	if lastAnimation.ends_with("attack"):
		inAttackAnimation = false;
		knightSwordHitbox.disabled = true;

func _on_knight_body_entered(body):
	if body.has_method('takeDamage'):
		body.takeDamage(5);

func _on_knight_delayTimer_timeout(delayTimer: Timer) -> void:
	knightSwordHitbox.disabled = false;
	delayTimer.queue_free();

func _on_dashSpeedTimer_timeout(speedTimer: Timer) -> void:
	MAX_SPEED /= DASH_MULTIPLIER;
	ACCELERATION /= DASH_MULTIPLIER;
	speedTimer.queue_free();

func _on_dashCooldownTimer_timeout(cooldownTimer: Timer) -> void:
	_dashCooldownAvalailable = true;
	cooldownTimer.queue_free();
