extends Node

enum Items {
	NONE,
	SPONGE,
	ROPE
}
var current_item : Items = Items.NONE
signal lamp_state_changed(state : bool)

var level := 1
