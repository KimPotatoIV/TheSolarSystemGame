extends CanvasLayer

##################################################
@onready var game_over_label = $GameOverLabel
@onready var score_label = $ScoreLabel

var score = 0

##################################################
func _ready() -> void:
	game_over_label.visible = false

##################################################
func _process(delta: float) -> void:
	if GameManager.get_game_over():
		game_over_label.visible = true
		
	if score != GameManager.get_score():
		score = GameManager.get_score()
		score_label.text = "SCORE\n" + str(GameManager.get_score()).pad_zeros(5)
