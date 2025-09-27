extends Node2D

@onready var timer: Timer = $Timer
@onready var sheep: StaticBody2D = $sheep
@onready var label: Label = $Label
@onready var anim: AnimationPlayer = $AnimationPlayer


var spawnTime = 5
@export var score = 0
var quota = 1
@export var harpoon = false
var upgrading = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	anim.play("RESET")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var remaining = str(quota - score)
	if int(remaining) == 0 and !upgrading:
		upgrading = true
		label.text = "THE HOLE GIVES BACK"
		if !harpoon:
			anim.play("rise")
			quota = 1
			score = 0
		else:
			label.text = "THE HOLE IS ACCEPTING DONATIONS"
	elif upgrading == false:
		label.text = "THE HOLE REQUIRES " + remaining + " MORE SHEEP"
		

func _on_timer_timeout() -> void:
	timer.start(spawnTime)
	var copy = sheep.duplicate()
	add_child(copy)
	copy.position.x = ((randi_range(0,1) -.5) * 2) * 350
	copy.ragdoll = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "rise":
		label.text = "RIGHT CLICK TO HARPOON SHEEP"
		await get_tree().create_timer(2.0).timeout
		harpoon = true
		upgrading = false
		anim.play("RESET")
		
