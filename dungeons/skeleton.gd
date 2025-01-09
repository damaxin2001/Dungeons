extends CharacterBody2D  # Usando CharacterBody2D para movimento físico

@export var speed: float = 50  # Velocidade do mob
@export var attack_range: float = 5  # Distância do ataque
@export var attack_damage: int = 100  # Dano do ataque

var player : Node = null  # Referência ao jogador
var is_attacking : bool = false
var direction : Vector2 = Vector2.ZERO

var animated_sprite : AnimatedSprite2D = null  # Referência ao AnimatedSprite2D

func _ready():
	player = get_node("/root/Node2D/CharacterBody2D")  # Ajuste o caminho do jogador
	animated_sprite = $AnimatedSprite2D  # Assumindo que você tem um AnimatedSprite2D como filho

func _process(delta):
	if player:
		var distance_to_player = global_position.distance_to(player.global_position)
		
		# Verifica se o jogador está perto o suficiente para atacar
		if distance_to_player < attack_range and not is_attacking:
			attack()
		else:
			move_towards_player(distance_to_player, delta)

func move_towards_player(distance, delta):
	if distance > attack_range:
		# Direção do movimento em direção ao jogador
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		# Usando move_and_slide() para mover o mob
		move_and_slide()

		# Animações baseadas na direção
		if velocity.length() > 0:
			animated_sprite.play("skeleton_walk")
		else:
			animated_sprite.play("skeleton_idle")

func attack():
	is_attacking = true
	animated_sprite.play("skeleton_attack")  # Troca para animação de ataque
	
	# Depois de terminar a animação de ataque, resete o estado.
	await(animated_sprite)
	is_attacking = false

# Detecta quando o jogador entra na área de ataque
func _on_Area2D_body_entered(body):
	if body.is_in_group("player") and is_attacking:
		body.take_damage(attack_damage)  # Supondo que você tenha uma função de dano no script do jogador
