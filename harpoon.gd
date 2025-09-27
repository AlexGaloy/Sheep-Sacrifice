extends StaticBody2D

@onready var farmer: CharacterBody2D = $"../farmer"
@onready var chain: Line2D = $chain
@onready var tip: CollisionShape2D = $tip/CollisionShape2D


var done = false
var velocity: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("harpoon") and !visible and $"..".harpoon:
		show()
		var angle = farmer.global_position.angle_to_point(get_global_mouse_position())
		rotation = angle + PI/2.0
		velocity = Vector2(6*cos(angle),6*sin(angle))
	move_and_collide(velocity)
	chain.set_point_position(1,to_local(farmer.global_position))
	var point1 = chain.get_point_position(0)
	var point2 = chain.get_point_position(1)
	if point1.distance_to(point2) > 300 or done:
		done = false
		hide()
		velocity = Vector2.ZERO
	if !visible:
		position = farmer.position
	tip.disabled = !visible

func _on_sheep_pooned() -> void:
	done = true
