extends KinematicBody2D

export var move_speed = 200.0

var velocity := Vector2.ZERO

export var jump_height : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
var second_jump = true
var knockback_dir = Vector2()
var knockback_wait = 10

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	velocity.x = get_input_velocity() * move_speed
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		$AnimatedSprite.play("jump")
		jump()
	if Input.is_action_just_pressed("ui_up") and !is_on_floor() and second_jump:
		second_jump= false
		$AnimatedSprite.play("second_jump")
		jump()
	if is_on_floor() and !second_jump:
		second_jump= true
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.x > 0 and is_on_floor():
		$AnimatedSprite.play("run")
	elif velocity.x == 0 and is_on_floor():
		$AnimatedSprite.play("idle")
	if velocity.x != 0 :
		if velocity.x != 0 and is_on_floor():
			$AnimatedSprite.play("run")
		# Flip in different direction
		$AnimatedSprite.flip_h = velocity.x < 0
	if (get_slide_count() > 0):
		for i in range(get_slide_count()):
			if "Fruit" in get_slide_collision(i).collider.name:
				touched(get_slide_collision(i).collider.name)
			if "Enemy" in get_slide_collision(i).collider.name:
				hurt(get_slide_collision(i).collider.name)
	
func touched(name):
	var object  ="../{a}".format({"a":name})
	var fruta = get_node(object)
	fruta.get_node("CollisionShape2D").disabled=true
	fruta.get_node("AudioStreamPlayer2D").play()
	fruta.hide()

func hurt(name):
	$AnimatedSprite.play("hit")
	$AudioStreamPlayer2D.play()

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump():

	velocity.y = jump_velocity
	

func get_input_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("ui_left"):
		horizontal -= 1.0
	if Input.is_action_pressed("ui_right"):
		horizontal += 1.0
	
	return horizontal
