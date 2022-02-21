extends Area2D





func _ready():
	pass




func _on_oilSpill_large_body_entered(body):
	add_to_group(str(body) + "oil")
	pass # Replace with function body.


func _on_oilSpill_large_body_exited(body):
	remove_from_group(str(body) + "oil")
