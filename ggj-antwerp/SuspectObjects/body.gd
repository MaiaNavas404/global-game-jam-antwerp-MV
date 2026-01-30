extends RigidBody2D

@onready var mouse_drag_area := $MouseDragArea
var draggable := false
var dragging := false
var mouse_offset := Vector2.ZERO

func _ready():
	mouse_drag_area.mouse_entered.connect(_on_mouse_entered)
	mouse_drag_area.mouse_exited.connect(_on_mouse_exited)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and draggable:
		dragging = true
		mouse_offset = position - get_global_mouse_position()
	if dragging:
		position = get_global_mouse_position() + mouse_offset
	if Input.is_action_just_released("click"):
		dragging = false

func _on_mouse_entered() -> void:
	draggable = true


func _on_mouse_exited() -> void:
	draggable = false
