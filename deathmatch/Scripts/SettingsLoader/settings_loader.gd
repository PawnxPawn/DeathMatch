extends Node

const master_volume_bus_name: String = "Master"
const master_volume_key: String = "master_volume"
const music_volume_bus_name: String = "Music"
const music_volume_key: String = "music_volume"
const sfx_volume_bus_name: String = "SFX"
const sfx_volume_key: String = "sfx_volume"

var bus_index: int

func _ready() -> void:
    load_and_apply_settings()


func load_and_apply_settings() -> void:
    var audio_settings: Dictionary[String, Variant] = ConfigFileHandler.load_settings("audio")

    bus_index = AudioServer.get_bus_index(master_volume_bus_name)
    AudioServer.set_bus_volume_db(bus_index, linear_to_db(audio_settings[master_volume_key].value))

    bus_index = AudioServer.get_bus_index(music_volume_bus_name)
    AudioServer.set_bus_volume_db(bus_index, linear_to_db(audio_settings[music_volume_key].value))

    bus_index = AudioServer.get_bus_index(sfx_volume_bus_name)
    AudioServer.set_bus_volume_db(bus_index, linear_to_db(audio_settings[sfx_volume_key].value))