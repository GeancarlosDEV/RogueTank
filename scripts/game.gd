extends Node

var score = 0 setget set_score

signal score_changed

func _ready():
	pass # Replace with function body.

func add_score(val):
	score += val
	emit_signal("score_changed")
	#print(score)

func set_score(val):
	
	pass
