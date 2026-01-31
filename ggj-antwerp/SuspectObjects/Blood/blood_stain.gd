extends Node2D

@export var STAIN_CAPACITY := 4

@onready var stain_life = STAIN_CAPACITY
var current_color : Color
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_color = $Sprite2D.modulate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print($Sprite2D.modulate.a)


func _on_area_2d_area_exited(area: Area2D) -> void:
	stain_life -= 1
	if stain_life == 0:
		queue_free()
	else:
		$Sprite2D.modulate.a = float(stain_life) / float(STAIN_CAPACITY)
