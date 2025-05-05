extends Node

var config: ConfigFile = ConfigFile.new()
const SETTINGS_FILE_PATH: String = "user://settings.ini"

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "music_volume", 1.0)
		config.set_value("audio", "sfx_volume", 1.0)
		config.save(SETTINGS_FILE_PATH)

	else:
		config.load(SETTINGS_FILE_PATH)

func save_audio_settings(category: String, key: String, value: float) -> void:
	config.set_value(category, key, value)
	config.save(SETTINGS_FILE_PATH)

func load_audio_settings(category: String) -> Dictionary[String, float]:
	var settings: Dictionary[String, float] = {}
	for k in config.get_section_keys(category):
		settings[k] = config.get_value(category, k)

	return settings
