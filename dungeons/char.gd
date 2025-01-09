extends CharacterBody2D

@export var speed: float = 100
var spawn_position : Vector2 = Vector2(111, 210)  


func _on_Lava_body_entered(body):
	if body.is_in_group("player"):
		print("LAVAAAAAAAA")
		die_and_respawn()

func die_and_respawn():
	global_position = spawn_position 

	
func _process(delta):
	var direction = Vector2.ZERO

	# Movimento básico
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	# Normalizar para evitar movimento diagonal mais rápido
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

	# Trocar animação
	if direction != Vector2.ZERO:
		$AnimatedSprite2D.play("walking")
	else:
		$AnimatedSprite2D.play("waiting")
