extends Node2D

var is_disabled := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if globals.current_item == globals.Items.SPONGE:
		position = get_global_mouse_position()
		if is_disabled:
			visible = true
			is_disabled = false
	elif !is_disabled:
		visible = false
		is_disabled = true
