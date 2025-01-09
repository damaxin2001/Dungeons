extends CharacterBody2D

@export var speed: float = 100
var spawn_position: Vector2 = Vector2(111, 210)


# Variáveis de controle
var is_action_playing: bool = false
var is_dying: bool = false

func _on_Lava_body_entered(body):
	if body.is_in_group("player") and not is_dying:
		print("LAVAAAAAAAA")
		die()

func die():
	is_dying = true
	$AnimatedSprite2D.play("death")

func _on_AnimatedSprite2D_animation_finished():
	if is_dying:
		respawn()
	else:
		# Finaliza ações como hammering ou attack
		is_action_playing = false

func respawn():
	global_position = spawn_position
	is_dying = false

func _process(delta):
	var direction = Vector2.ZERO

	# Detecta ações de hammering ou attack
	if not is_action_playing and not is_dying:
		if Input.is_action_just_pressed("ui_hammering"):
			$AnimatedSprite2D.play("hammering")
			is_action_playing = true
		elif Input.is_action_just_pressed("ui_attack"):
			$AnimatedSprite2D.play("attack")
			is_action_playing = true

	# Movimento básico (somente se nenhuma ação especial está em andamento)
	if not is_action_playing and not is_dying:
		if Input.is_action_pressed("ui_right"):
			direction.x += 1
		if Input.is_action_pressed("ui_left"):
			direction.x -= 1
		if Input.is_action_pressed("ui_down"):
			direction.y += 1
		if Input.is_action_pressed("ui_up"):
			direction.y -= 1

		# Normalizar direção e movimentar o jogador
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()

		# Alternar entre animações de movimento e idle
		if direction != Vector2.ZERO:
			$AnimatedSprite2D.play("walking")
		else:
			$AnimatedSprite2D.play("waiting")


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_dying:
		respawn()
	else:
		# Finaliza ações como hammering ou attack
		is_action_playing = false
