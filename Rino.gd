extends KinematicBody2D

var speed = 2000
var collision
var direccion = -1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var sigth = $RayCast2D
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("idle")
	pass # Replace with function body.

func _physics_process(delta):
	var movement = Vector2()
	var flip = true
	
	if sigth.is_colliding():
		speed = 4000
	else: 
		speed = 2000
	movement = Vector2() #Reinicia el valor
	collision = move_and_collide(movement * delta)

	#if (position.x < 15): #Derecha
	#	direccion = 1
	#elif(position.x > (screen_size.x - 10)): #Izquierda
	#	direccion = direccion * (-1)
	
	movement.x += direccion
	
	if movement.length() > 0: #Verificar si esta en movimietno
		movement = movement.normalized() * speed #Normalizar
	
	move_and_slide(movement * delta)
	
	if (is_on_wall() || get_slide_count() > 0):
		direccion = direccion * (-1)
		if direccion<0:
			sigth.set_cast_to(Vector2(-107,0))
			
		else:
			sigth.set_cast_to(Vector2(107,0))
			
	if (get_slide_count() > 0):
		for i in range(get_slide_count()):
			if "Player" in get_slide_collision(i).collider.name:
				touched(get_slide_collision(i).collider.name)
	#position +=  #Actualizar los movimientos
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	
	if movement.x != 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = direccion > 0
	else: 
		$AnimatedSprite.play("idle")

func touched(name):
	var object  ="../{a}".format({"a":name})
	var player = get_node(object)
	player.hurt(name)
