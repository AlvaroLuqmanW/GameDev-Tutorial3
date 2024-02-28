extends KinematicBody2D

export (int) var speed = 400
export (int) var jump_speed = -600
export (int) var max_jumps = 2  # Number of jumps allowed, including the initial jump
export (int) var GRAVITY = 1200

const UP = Vector2(0, -1)


var crouch_texture : Texture = load("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_duck.png")
var idle_texture : Texture = load("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_idle.png")
var jump_texture: Texture = load("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_jump.png")
var walk_texture: Texture = load("res://assets/kenney_platformercharacters/PNG/Adventurer/Poses/adventurer_walk1.png")

var velocity = Vector2()
var jumps_remaining = 0

var crouching = false

func get_input():
	velocity.x = 0
	var sprite = get_node("Sprite")

	if is_on_floor():
		jumps_remaining = max_jumps

	if Input.is_action_just_pressed('ui_up') and jumps_remaining > 0:
		sprite.texture = jump_texture
		velocity.y = jump_speed
		jumps_remaining -= 1
	
	if Input.is_action_just_released('ui_up'):
		sprite.texture = idle_texture

	if Input.is_action_pressed('ui_right'):
		sprite.flip_h = false
		if crouching:
			sprite.texture = crouch_texture
		else:
			sprite.texture = walk_texture
		velocity.x += speed
		
	if Input.is_action_pressed('ui_left'):
		sprite.flip_h = true
		if crouching:
			sprite.texture = crouch_texture
		else:
			sprite.texture = walk_texture
		velocity.x -= speed
		
	if Input.is_action_just_released('ui_right'):
		if crouching:
			sprite.texture = crouch_texture
		else:
			sprite.texture = walk_texture
		velocity.x += speed
		
	if Input.is_action_just_released('ui_left'):
		if crouching:
			sprite.texture = crouch_texture
		else:
			sprite.texture = walk_texture
		velocity.x -= speed
		
	if Input.is_action_just_pressed("ui_down"):
		crouching = true
		speed = speed/2
		sprite.texture = crouch_texture
		
	if Input.is_action_just_released('ui_down'):
		crouching = false
		speed = 400
		sprite.texture = idle_texture

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	get_input()
	velocity = move_and_slide(velocity, UP)



