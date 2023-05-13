extends CanvasLayer

var lb_game_id
var lb_player
var lb_total_time
var lb_session_time
var lb_player_position_x
var lb_player_position_y
var lb_player_direction


func _ready():
	lb_game_id = $OverlayLeft/VBoxContainer/GameID/ID
	lb_total_time = $OverlayLeft/VBoxContainer/PlayTime/PlayTime
	lb_session_time = $OverlayLeft/VBoxContainer/SessionTime/SessionTime
	lb_player = $OverlayLeft/VBoxContainer/PlayerName/PlayerName
	lb_player_position_x = $OverlayLeft/VBoxContainer/PlayerPosition/PlayerPositionX
	lb_player_position_y = $OverlayLeft/VBoxContainer/PlayerPosition/PlayerPositionY
	lb_player_direction = $OverlayLeft/VBoxContainer/PlayerDirection/Direction
	
func _unhandled_input(event):
	if event.is_action_pressed("toggle_dev"):
		self.visible = !visible

func _physics_process(_delta):
	lb_game_id.text = SaveManager.current_game_save_key
	lb_player.text = StoryManager.get_player_name()
	lb_total_time.text = str(Utils.get_game_timer().minutes_passed)
	lb_session_time.text = str(Utils.get_game_timer().minutes_base - Utils.get_game_timer().minutes_passed)
	if Utils.get_player() != null:
		var player_position = Utils.get_player().position
		lb_player_position_x.text = str(int(player_position.x))
		lb_player_position_y.text = str(int(player_position.y))
		lb_player_direction.text = str(Utils.get_player().get_player_direction())
