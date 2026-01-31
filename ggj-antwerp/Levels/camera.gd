extends Camera2D

@export var PAN_SPEED := 1000.0
@export var bounds : Vector2
@export var left_pan_marker : Marker2D
@export var right_pan_marker : Marker2D
var camera_move_direction := Vector2.ZERO


func _ready():
	bounds.y -= 1920

func _physics_process(delta: float) -> void:
	update_direction()
	if position.x < bounds.x:
		camera_move_direction.x = 0
		position.x = bounds.x
	elif position.x > bounds.y:
		camera_move_direction.x = 0
		position.x = bounds.y
	position += camera_move_direction * PAN_SPEED * delta
	
	

func update_direction():
	if get_global_mouse_position().x < left_pan_marker.global_position.x and position.x > bounds.x:
		camera_move_direction.x = -1
	elif get_global_mouse_position().x > right_pan_marker.global_position.x and position.x < bounds.y:
		camera_move_direction.x = 1
	else:
		camera_move_direction.x = 0
