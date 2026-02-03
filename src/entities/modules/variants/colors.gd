extends Module
class_name ColorsModule


signal color_changed(new_color: Color)


var color = Color.LIGHT_BLUE


func set_color(new_color: Color) -> void:
    color = new_color
    color_changed.emit(new_color)
