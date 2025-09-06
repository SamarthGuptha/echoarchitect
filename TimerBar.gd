class_name TimerBar
extends ProgressBar

func update_progress(time_left, max_time):
	if max_time>0:
		value = (time_left / max_time)*100
	else:
		value = 0
