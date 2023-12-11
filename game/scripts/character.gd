extends KinematicBody2D

onready var animationPlayer: AnimatedSprite = $Pivot/spriteFrames;

var currentCharacter: String = "knight";
const CHARACTER_SCALES: Dictionary = {
	"knight": Vector2(2,2),
	"archer": Vector2(2,2),
	"shotgunner": Vector2(2,2)
}

var inAttackAnimation: bool = false;

const FRICTION = 500;
var ACCELERATION = 25000;
var MAX_SPEED = 500;

var velocity = Vector2.ZERO;

signal playerMoved(newPosition);

# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("default");
	# warning-ignore:return_value_discarded
	animationPlayer.connect("animation_finished", self, "_animationFinished");

func _input(_event):
	if Input.is_action_just_pressed("change_character"):
		currentCharacter = getNextCharacter(currentCharacter);
		handleNextCharacterSpawn();
	if Input.is_action_just_pressed("character_attack"):
		animationPlayer.play(currentCharacter + "_attack");
		inAttackAnimation = true;

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
	controlAnimations(velocity);

func getNextCharacter(character: String) -> String:
	var unlockedHeroes: Array = Global.getHeroesUnlocked();
	var found: bool = false;
	for hero in unlockedHeroes:
		if hero == character:
			found = true;
		if found:
			return hero;
	if found and len(unlockedHeroes) > 0:
		return unlockedHeroes[0];
	return "knight";

func handleNextCharacterSpawn():
	var newScale: Vector2 = CHARACTER_SCALES.get(currentCharacter);
	if newScale == null:
		newScale = Vector2(1,1);
	animationPlayer.scale = newScale;

func controlAnimations(vel: Vector2):
	if inAttackAnimation:
		return;
	vel = vel.normalized();
	animationPlayer.flip_h = vel.x < 0;
	if vel == Vector2.ZERO:
		animationPlayer.play(currentCharacter + "_idle");
	elif vel.x != 0 and vel.y == 0:
		animationPlayer.play(currentCharacter + "_move");
	else:
		animationPlayer.play(currentCharacter + "_move");

func _animationFinished():
	var lastAnimation: String = animationPlayer.animation;
	if lastAnimation.ends_with("attack"):
		inAttackAnimation = false;
