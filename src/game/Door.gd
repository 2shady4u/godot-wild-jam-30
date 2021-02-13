class_name Door
extends StaticBody2D

enum TYPE {LOCKED, BOSS}

export(TYPE) var type : int

# warning-ignore:unused_signal
signal opened

func _ready():
	pass # Rseplace with function body.
