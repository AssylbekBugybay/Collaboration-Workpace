extends KinematicBody2D


export (float) var speed: float = 200.0

# onready var participant_name: Label = $Name
onready var animation_player: AnimationPlayer = $AnimationPlayer
# onready var sprites_m: Node2D = $SpritesM
onready var interaction_area: Area2D = $InteractionArea

var velocity: Vector2 = Vector2(0.0, 0.0)
var direction: Vector2 = Vector2(0.0, 1.0)
var current_animation: String = "idle_s"

# The puppet keyword means a call can be made from the network master to any network puppet.
puppet var puppet_pos: Vector2 = Vector2()
puppet var puppet_motion: Vector2 = Vector2()
puppet var puppet_current_animation: String = "idle_s"

func _ready() -> void:
	print("Participant: _ready()")
#	set_participant_name (GlobalData.participant_data["Name"])

func _process(_delta: float) -> void:
	# TODO 
	# Not sure what is happening here, ask Fatma and Yufus
	if is_network_master():
		get_input()
		rset("puppet_motion", velocity)
		rset("puppet_pos", position)
	else:
		position = puppet_pos
		velocity = puppet_motion
	
	velocity = move_and_slide(velocity)
	
	if not is_network_master():
		puppet_pos = position
	
	decide_animation()
	animation_player.play(current_animation)

func set_data(new_data: Dictionary) -> void:
	$Name.text = new_data["Name"]
	set_selected_color(new_data)


func set_participant_camera(active: bool) -> void:
	$Camera.current = active


func set_selected_color(new_data: Dictionary) -> void:
	$SpritesM.get_node("Hair").modulate = new_data["Color"]["Hair"]
	$SpritesM.get_node("Eyes").modulate = new_data["Color"]["Eyes"]
	$SpritesM.get_node("Skin").modulate = new_data["Color"]["Skin"]
	$SpritesM.get_node("Shirt").modulate = new_data["Color"]["Shirt"]
	$SpritesM.get_node("Pants").modulate = new_data["Color"]["Pants"]
	$SpritesM.get_node("Shoe").modulate = new_data["Color"]["Shoe"]


func get_input() -> void:
	if (Input.is_action_pressed("ui_right") or
		Input.is_action_pressed("ui_left") or
		Input.is_action_pressed("ui_down") or
		Input.is_action_pressed("ui_up")
	):
		direction = Vector2(0.0, 0.0)
	
	velocity = Vector2(0.0, 0.0)
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		direction.x = 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		direction.x =-1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		direction.y = 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		direction.y = -1
	velocity = velocity.normalized() * speed

# Update current animation (current player direction and velocity)
# s = south, se = southeast, ...
func decide_animation() -> void:
	if is_network_master():
		if direction.x == 0 and direction.y > 0:
			if velocity.length() == 0:
				current_animation = "idle_s"
			else:
				current_animation = "walk_s"
		elif direction.x > 0 and direction.y > 0:
			if velocity.length() == 0:
				current_animation = "idle_se"
			else:
				current_animation = "walk_se"
		elif direction.x > 0 and direction.y == 0:
			if velocity.length() == 0:
				current_animation = "idle_e"
			else:
				current_animation = "walk_e"
		elif direction.x > 0 and direction.y < 0:
			if velocity.length() == 0:
				current_animation = "idle_ne"
			else:
				current_animation = "walk_ne"
		elif direction.x == 0 and direction.y < 0:
			if velocity.length() == 0:
				current_animation = "idle_n"
			else:
				current_animation = "walk_n"
		elif direction.x < 0 and direction.y < 0:
			if velocity.length() == 0:
				current_animation = "idle_nw"
			else:
				current_animation = "walk_nw"
		elif direction.x < 0 and direction.y == 0:
			if velocity.length() == 0:
				current_animation = "idle_w"
			else:
				current_animation = "walk_w"
		elif direction.x < 0 and direction.y > 0:
			if velocity.length() == 0:
				current_animation = "idle_sw"
			else:
				current_animation = "walk_sw"
		rset("puppet_current_animation", current_animation)
	else:
		current_animation = puppet_current_animation




