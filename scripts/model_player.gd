extends CharacterBody2D

@export_range(100.0, 400.0) var speed = 400.0
@export var sprint_speed:float

var stun_time:Timer = Timer.new()
var slowmove:bool = false
@export var inv:Inv

var can_move:bool = false

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	stun_time.wait_time = RandomNumberGenerator.new().randf_range(0.7, 1.4)
	stun_time.one_shot = true
	add_child(stun_time)
	Global.player = self
	Dialogic.signal_event.connect(dialogsignal)
func _process(delta):
	#print(stun_time.is_stopped())
	if can_move:
		var dir = Input.get_vector("left", "right", "up", "down")
		if Input.is_action_pressed("sprint") and not slowmove:
			velocity = lerp(velocity, dir * sprint_speed, 0.2)
		elif slowmove:
			velocity = lerp(velocity, dir * speed * 0.5, 0.2)
		elif not slowmove:
			velocity = lerp(velocity, dir * speed, 0.2)
		if dir:
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("idle")
		move_and_slide()
		if get_global_mouse_position().x < global_position.x:
			$AnimatedSprite2D.scale.x = -1
		else:
			$AnimatedSprite2D.scale.x = 1
	Global.health = $health_component.health

func _on_health_component_damage_incoming() -> void:
	# Shake Screen effect
	Global.camera.get_node("Node2D").shake(1.0, 1.0)
	Global.screenfx.enable_effect()
	if stun_time.is_stopped():
		stun_time.start()
	pass

func collect(item:InvItem):
	inv.insert(item)
	if item.is_weapon:
		$weapon.add_weapon(item.weapon)

func cutscene(scene:String):
	var dialog = Dialogic.start(scene)
	#can_move = false
	Global.UI.get_node("AnimationPlayer").play('cut_scene')

func dialogsignal(namesignal):
	print(namesignal)
	if namesignal == "exited":
		can_move = true
		Global.UI.get_node("AnimationPlayer").play('cut_scene_finished')
		
