extends Node2D
func _ready():
	$Timer_queue.wait_time = rand_range(8 , 16)
	$Timer_queue.start()
	
func _on_Timer_queue_timeout():
	$anim.play("fade")
	yield($anim, "animation_finished")
	queue_free()
	pass 
