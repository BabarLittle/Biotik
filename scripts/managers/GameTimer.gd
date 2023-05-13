extends Timer

signal SignalAmbientChanging

enum SunlightState {DAY=0, NIGHT=1}

export (Color) var sunlight = Color(1,1,1,1)
export (Color) var nightlight = Color(0.239216,0.231373,0.313726,1)
export (Color) var sunrise = Color(0.76,0.49,0.05,1)
export (Color) var sunset = Color(0.76,0.49,0.05,1)
export var day_duration_minutes = 2
export var night_duration_minutes = 2
export var sun_speed_seconds = 30

var minutes_passed = 0
var minutes_base = 0
var current_state_time = day_duration_minutes
var sunlight_state = SunlightState.DAY

func connect_to_timer(target):
	assert(connect("SignalAmbientChanging", target, "update_ambient_light") == 0, "Could not connect to ambient light")

func _on_GameTimer_timeout():
	minutes_passed += 1
	current_state_time -= 1
	calculate_sunlight_state()
		
	
func set_minutes_played(minutes):
	minutes_passed = minutes
	minutes_base = minutes
	current_state_time = minutes_passed % (day_duration_minutes+night_duration_minutes)
	if current_state_time >= day_duration_minutes:
		current_state_time -= day_duration_minutes
		sunlight_state = SunlightState.NIGHT
	else:
		sunlight_state = SunlightState.NIGHT
	calculate_sunlight_state()
	
func get_minutes_played():
	return minutes_passed

func get_time_played():
	if minutes_passed == 0:
		return "0 min !"
	elif minutes_passed < 5:
		return "Not enough"
	elif minutes_passed > 600:
		return "Way too much"
		
	var minutes = minutes_passed%60
	var hours = (minutes_passed/60)/60

	#returns a string with the format "HH:MM:SS"
	return "%02d:%02d" % [hours, minutes]

func calculate_sunlight_state():
	var color_transition
	print("Tic tac tic tac : " + str(current_state_time))
	if current_state_time == 0:
		match sunlight_state:
			SunlightState.DAY:
				current_state_time = night_duration_minutes
				sunlight_state = SunlightState.NIGHT
				color_transition = sunset
				print("Night is falling")
			SunlightState.NIGHT:
				current_state_time = day_duration_minutes
				sunlight_state = SunlightState.DAY
				color_transition = sunrise
				print("Cocoricooo")
		emit_signal("SignalAmbientChanging", light_state(), sun_speed_seconds, color_transition)
	
func light_state():
	match sunlight_state:
		SunlightState.DAY:
			return sunlight
		SunlightState.NIGHT:
			return nightlight

func get_period_string():
	match sunlight_state:
		SunlightState.DAY:
			return "day"
		SunlightState.NIGHT:
			return "night" 
