extends CharacterBody2D
var player:Node2D
@export var speed:float
var state:String = "idle"
var knockback_velocity:Vector2
var follow_velocity:Vector2

func _ready() -> void:
	change_state("idle")

func follow_player_direction():
	return (Global.player.global_position - global_position).normalized() * speed

func follow_player(dir):
	if (Global.player.global_position - global_position).distance_to(Vector2.ZERO) > 100:
		follow_velocity = follow_velocity.move_toward(dir, 10.0)
	else:
		follow_velocity = follow_velocity.move_toward(Vector2.ZERO, 2.0)
	velocity = follow_velocity+knockback_velocity

func _physics_process(delta: float) -> void:
	var direction:Vector2 = follow_player_direction()
	if direction.x < 0.0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
	follow_player(direction)
	move_and_slide()
	$Taser.update_taser_position(Global.player.global_position)
	if Input.is_action_just_pressed("inventory"):
		$Taser.shoot()
	if Input.is_action_just_pressed("interact"):
		$Taser.retract()
func change_state(new_state):
	state = new_state
	$AnimatedSprite2D.play(state)
