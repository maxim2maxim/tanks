extends CharacterBody2D

var name_my
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = self.name
	
var speed = 25000
func _physics_process(delta: float) -> void:
	
	
	if multiplayer.has_multiplayer_peer() and is_multiplayer_authority():
		velocity.x = 0
		velocity.y = 0



		if Input.is_action_pressed("go_left"):
			velocity.x -= speed * delta
		if Input.is_action_pressed("go_right"):
			velocity.x += speed * delta
		if Input.is_action_pressed("go_up"):
			velocity.y -= speed * delta
		if Input.is_action_pressed("go_down"):
			velocity.y += speed * delta


		move_and_slide()
