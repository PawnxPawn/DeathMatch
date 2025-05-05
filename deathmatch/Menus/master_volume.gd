extends VBoxContainer

@export var bus_name: String #Not a fan of Strings, but I do not know of an alternative.
@export var volume_slider: HSlider

var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func _on_volume_slider_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	
	match (bus_name):
		"Master":
			ConfigFileHandler.save_settings("audio", "master_volume", volume_slider.value)
		"Music":
			ConfigFileHandler.save_settings("audio", "music_volume", volume_slider.value)
		"SFX":
			ConfigFileHandler.save_settings("audio", "sfx_volume", volume_slider.value)