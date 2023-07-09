extends Node2D

var board_size = 420
var cell_size = 30.0
var default_size = 60.0
var board = Image.create(board_size, board_size, false, Image.FORMAT_RGBA8)
var score = 0


func _ready():
	#Build the starting board.
	for x in range(0, board_size, cell_size):
		for y in range(0, board_size, cell_size):
			board.fill_rect(Rect2i(x,y, int(cell_size), int(cell_size)), Color(color()))
	$txRectBoard.texture = ImageTexture.create_from_image(board)


func color():
	#Choose a random color
	var rnd = randi() % 6 + 1
	var rnd_color
	match (rnd):
		1: rnd_color = "blue"
		2: rnd_color = "green"
		3: rnd_color = "orange"
		4: rnd_color = "pink"
		5: rnd_color = "red"
		6: rnd_color = "yellow"
	return rnd_color


func flood(select_color):
	var saved_cell_color = board.get_pixelv(Vector2(0,0))
	if saved_cell_color != Color(select_color):
		var cells_array = [Vector2(0,0)]
		var current_cell
		var directions = [Vector2(cell_size, 0), Vector2(0, cell_size), Vector2(-cell_size, 0), Vector2(0, -cell_size)]
		while cells_array.size() > 0:
			current_cell = cells_array.pop_back()
			if saved_cell_color == board.get_pixelv(current_cell):
				board.fill_rect(Rect2i(current_cell.x, current_cell.y, int(cell_size), int(cell_size)), Color(select_color))
				for dir in directions:
					if current_cell.x + dir.x >= 0 and current_cell.x + dir.x < board_size:
						if current_cell.y + dir.y >= 0 and current_cell.y + dir.y < board_size:
							if saved_cell_color == board.get_pixelv(current_cell + dir):
								if cells_array.find(current_cell + dir) == -1:
									cells_array.append(current_cell + dir)
		$txRectBoard.texture = ImageTexture.create_from_image(board)
		set_score()
		if is_victory():
			disable_buttons(true)
			$lblScore.text = "Você venceu!"
		else:
			if is_defeat():
				disable_buttons(true)
				$lblScore.text = "Você perdeu!"

func is_victory():
	var fill_color = board.get_pixelv(Vector2(0,0))
	for x in range(0, board_size, cell_size):
		for y in range(0, board_size, cell_size):
			if fill_color != board.get_pixelv(Vector2(x,y)):
				return false
	return true


func is_defeat():
	if score >= 25:
		return true
	return false


func set_score():
	score += 1
	$lblScore.text = str(score) + "/25"


func disable_buttons(state):
	$btnBlue.disabled = state
	$btnGreen.disabled = state
	$btnOrange.disabled = state
	$btnPink.disabled = state
	$btnRed.disabled = state
	$btnYellow.disabled = state


func _on_btn_blue_pressed():
	flood("blue")


func _on_btn_green_pressed():
	flood("green")


func _on_btn_orange_pressed():
	flood("orange")


func _on_btn_pink_pressed():
	flood("pink")


func _on_btn_red_pressed():
	flood("red")


func _on_btn_yellow_pressed():
	flood("yellow")


func _on_btn_back_pressed():
	get_tree().reload_current_scene()

