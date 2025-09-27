extends CharacterBody2D


@onready var sprite: AnimatedSprite2D = $sprite
@onready var foot: Area2D = $foot
@onready var shoe: CollisionShape2D = $foot/shoe


const SPEED = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("up"): #vertical movemetn
		velocity.y = -SPEED
	elif Input.is_action_pressed("down"):
		velocity.y = SPEED
	else: #vertical deacceleration
		velocity.y = velocity.y/1.5
		if abs(velocity.y) <= 1:
			velocity.y = 0
	if Input.is_action_pressed("right"): #horizontil movement
		velocity.x = SPEED
		sprite.flip_h = false
		foot.position.x = 22
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		sprite.flip_h = true
		foot.position.x = -22
	else: #horizontil deaccelerate
		velocity.x = velocity.x/1.5
		if abs(velocity.x) <= 1:
			velocity.x = 0
	if sprite.animation != "kick": #set walking animation
		if velocity == Vector2.ZERO: 
			sprite.set_animation("idle")
		else:
			sprite.play("walk")
	if Input.is_action_just_pressed("kick"):
		print("kicking")
		sprite.play("kick")
		shoe.disabled = false
	move_and_slide()

func _on_sprite_animation_finished() -> void:
	if sprite.animation == "kick":
		print("stopped")
		shoe.disabled = true
		sprite.set_animation("idle")
