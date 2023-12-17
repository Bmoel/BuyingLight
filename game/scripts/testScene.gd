extends Node2D

func _ready():
	$Character/collisionBox.disabled = true;
	$Character/takeDamageArea/CollisionShape2D.disabled = true;
	$basicEnemy.room = 1;
	$BlinkingEnemy.room = 1;
	$basicEnemy/CollisionShape2D.disabled = true;
	$BlinkingEnemy/CollisionShape2D.disabled = true;

func _process(delta):
	$basicEnemy._playerMoved($Character.position);
	$BlinkingEnemy._playerMoved($Character.position);
