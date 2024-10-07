extends KinematicBody2D

# Variables for movement
var velocity = Vector2.ZERO
var speed = 200
var gravity = 800
var jump_force = -400

# States
var is_jumping = false
var is_crouching = false
var is_prone = false

# Heights
var normal_height = 64
var crouch_height = normal_height / 2
var prone_height = normal_height / 4

# Collision shape reference
onready var collision_shape = $CollisionShape2D

func _physics_process(delta):
	# Reset the x velocity
	velocity.x = 0

	# Check movement states
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed

	# Jump if on the ground and not crouching/prone
	if Input.is_action_just_pressed("ui_up") and not is_jumping and not is_crouching and not is_prone:
		velocity.y = jump_force
		is_jumping = true

	# Crouch
	if Input.is_action_pressed("ui_crouch") and not is_jumping:
		crouch()
	elif Input.is_action_pressed("ui_prone") and not is_jumping:
		prone()
	else:
		stand_up()

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		is_jumping = false

	# Move the player
	velocity = move_and_slide(velocity, Vector2.UP)

func crouch():
	if not is_crouching:
		is_crouching = true
		is_prone = false
		collision_shape.shape.height = crouch_height

func prone():
	if not is_prone:
		is_crouching = false
		is_prone = true
		collision_shape.shape.height = prone_height

func stand_up():
	if is_crouching or is_prone:
		is_crouching = false
		is_prone = false
		collision_shape.shape.height = normal_height
