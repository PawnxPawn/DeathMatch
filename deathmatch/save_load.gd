extends Node

const SAVEFILE = "user://savefile.save"

func _ready():
	load_score()

func save_score():
	var file: FileAccess = FileAccess.open(SAVEFILE, FileAccess.WRITE_READ)
	file.store_32(GameManager.high_score)
	file.close()

func load_score():
	var file: FileAccess = FileAccess.open(SAVEFILE, FileAccess.READ)
	if FileAccess.file_exists(SAVEFILE):
		GameManager.high_score = file.get_32()
		file.close()
	else:
		GameManager.high_score = 0
