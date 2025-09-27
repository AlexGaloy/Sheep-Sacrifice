extends StaticBody2D

@onready var farmer: CharacterBody2D = $"../farmer"
@onready var foot: Area2D = $"../farmer/foot"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coll: CollisionShape2D = $CollisionShape2D
@onready var hole: Area2D = $"../hole"
@onready var baa_1: AudioStreamPlayer2D = $baa1
@onready var baa_2: AudioStreamPlayer2D = $baa2
@onready var baa_3: AudioStreamPlayer2D = $baa3
@onready var baa_4: AudioStreamPlayer2D = $baa4
@onready var tip: Area2D = $"../harpoon/tip"

@onready var baas = [baa_1,baa_2,baa_3,baa_4]
var velocity: Vector2 = Vector2.ZERO
var ragdoll: bool = false
@export var lineY = randf_range(-150,150)
var direction = -sign(position.x)
var harpooned = false
signal pooned

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if name != "sheep":
		coll.disabled = ragdoll
		if sprite.animation != "fall":
			if ragdoll == true: #when kicked
				sprite.animation = "caught"
				if !velocity.is_zero_approx(): #decellerate
					velocity *= .97
					rotate(velocity.x/5.0)
				else: #get up
					rotation_degrees = 0
					lineY = position.y
					direction = -sign(position.x)
					sprite.flip_h = true if direction == -1 else false
					ragdoll = false
				move_and_collide(velocity)
			else: #walk
				if harpooned:
					pooned.emit()
					if !velocity.is_zero_approx(): #decellerate
						velocity *= .97
						rotate(velocity.x/5.0)
						move_and_collide(velocity)
					else:
						harpooned = false
						rotation_degrees = 0
						lineY = position.y
						direction = -sign(position.x)
						sprite.flip_h = true if direction == -1 else false
						ragdoll = false
				else:
					sprite.play("walk")
					velocity.x = .5 * direction
					move_and_collide(velocity)
					position.y = lineY + 10*sin(position.x/20)
	else:
		position.y = randf_range(-150,150)

func _on_area_2d_sheep_area_entered(area: Area2D) -> void:
	print(area)
	if area == foot: #when kicked
		baas.pick_random().play(randf_range(.75,1.25))
		print("OMG IT WORKED")
		ragdoll = true
		var angle = position.angle_to_point(farmer.position)
		velocity = Vector2(-5*cos(angle),-5*sin(angle))
	elif area == hole: 
		if ragdoll == true: #when fell
			position = Vector2.ZERO
			print("fell")
			sprite.play("fall")
		else: #when walking into hole
			direction *= -1
			sprite.flip_h = true if direction == -1 else false
	elif area == tip:
		harpooned = true
		var angle = position.angle_to_point(farmer.position)
		velocity = Vector2(6*cos(angle),6*sin(angle))

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "fall":
		queue_free()
		$"..".score += 1
