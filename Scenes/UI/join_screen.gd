extends Control

@onready var ip_text_edit: TextEdit = $CenterContainer/VBoxContainer/HBoxContainer/IPTextEdit

var server_ip: String = ""

func _ready():
	Lobby.multiplayer.connection_failed.connect(_on_join_failed)

func _on_join_server_button_pressed() -> void:
	SceneTransition.fade_to_black_with_message("Joining game...")
	await SceneTransition.fade_in_finished
	
	var err = Lobby.join_game(server_ip)
	if err != OK:
		printerr("Error joining game at ip %s. %s" % [server_ip, err])
		return
	

func _on_join_failed():
	SceneTransition.show_message("Failed to join server!")
	await get_tree().create_timer(2.0).timeout
	SceneTransition.fade_out()

func _on_ip_text_edit_text_changed() -> void:
	server_ip = ip_text_edit.text


func _on_host_server_button_pressed() -> void:
	Lobby.create_game()
