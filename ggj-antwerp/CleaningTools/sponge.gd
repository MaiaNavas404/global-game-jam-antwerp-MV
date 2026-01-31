extends Node2D

var disabled := true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !disabled:
		position = get_global_mouse_position()
