extends Module
class_name EventsModule


# Letters a-z
signal a_pressed
signal a_released
signal a_held
signal b_pressed
signal b_released
signal b_held
signal c_pressed
signal c_released
signal c_held
signal d_pressed
signal d_released
signal d_held
signal e_pressed
signal e_released
signal e_held
signal f_pressed
signal f_released
signal f_held
signal g_pressed
signal g_released
signal g_held
signal h_pressed
signal h_released
signal h_held
signal i_pressed
signal i_released
signal i_held
signal j_pressed
signal j_released
signal j_held
signal k_pressed
signal k_released
signal k_held
signal l_pressed
signal l_released
signal l_held
signal m_pressed
signal m_released
signal m_held
signal n_pressed
signal n_released
signal n_held
signal o_pressed
signal o_released
signal o_held
signal p_pressed
signal p_released
signal p_held
signal q_pressed
signal q_released
signal q_held
signal r_pressed
signal r_released
signal r_held
signal s_pressed
signal s_released
signal s_held
signal t_pressed
signal t_released
signal t_held
signal u_pressed
signal u_released
signal u_held
signal v_pressed
signal v_released
signal v_held
signal w_pressed
signal w_released
signal w_held
signal x_pressed
signal x_released
signal x_held
signal y_pressed
signal y_released
signal y_held
signal z_pressed
signal z_released
signal z_held

# Numbers 0-9
signal zero_pressed
signal zero_released
signal zero_held
signal one_pressed
signal one_released
signal one_held
signal two_pressed
signal two_released
signal two_held
signal three_pressed
signal three_released
signal three_held
signal four_pressed
signal four_released
signal four_held
signal five_pressed
signal five_released
signal five_held
signal six_pressed
signal six_released
signal six_held
signal seven_pressed
signal seven_released
signal seven_held
signal eight_pressed
signal eight_released
signal eight_held
signal nine_pressed
signal nine_released
signal nine_held

# Special keys
signal space_pressed
signal space_released
signal space_held
signal shift_pressed
signal shift_released
signal shift_held
signal ctrl_pressed
signal ctrl_released
signal ctrl_held
signal alt_pressed
signal alt_released
signal alt_held
signal escape_pressed
signal escape_released
signal escape_held
signal enter_pressed
signal enter_released
signal enter_held
signal tab_pressed
signal tab_released
signal tab_held
signal backspace_pressed
signal backspace_released
signal backspace_held


func _on_target_ready():
	super()
	target.keys_module.key_pressed.connect(
		func(key):
			_emit(key, "pressed")
	)
	target.keys_module.key_released.connect(
		func(key):
			_emit(key, "released")
	)
	target.keys_module.key_held.connect(
		func(key):
			_emit(key, "held")
	)


func _emit(key: CustomKey, event_type: String) -> void:
	var name = key.get_char().to_lower()
	
	if name.is_empty() and key.physical_keycode != 0:
		name = OS.get_keycode_string(key.physical_keycode).to_lower()
	
	if name.is_empty():
		return
	
	# Map special characters
	if name == " ":
		name = "space"
	
	# Map numbers to word names
	var number_map = {
		"0": "zero", "1": "one", "2": "two", "3": "three", "4": "four",
		"5": "five", "6": "six", "7": "seven", "8": "eight", "9": "nine"
	}
	if number_map.has(name):
		name = number_map[name]
	
	var signal_name = "%s_%s" % [name, event_type]
	
	if has_signal(signal_name):
		emit_signal(signal_name)
