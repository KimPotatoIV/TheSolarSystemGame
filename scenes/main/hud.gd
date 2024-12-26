extends CanvasLayer

##################################################
@onready var game_over_label: Label = $GameOverLabel
@onready var score_label: Label = $ScoreLabel
# 게임 오버 라벨과 점수 라벨

var score: int = 0
# 잦은 업데이트를 막기 위한 점수 저장 변수

##################################################
func _ready() -> void:
	game_over_label.visible = false
	# 게임 오버 라벨을 보이지 않도록 설정

##################################################
func _process(delta: float) -> void:
	game_over_label.visible = GameManager.get_game_over()
	# 게임 오버 여부를 확인 후 게임 오버 라벨이 보일지 아닐지 설정
		
	if score != GameManager.get_score():
		score = GameManager.get_score()
		score_label.text = "SCORE\n" + \
			str(GameManager.get_score()).pad_zeros(5)
	# 점수 저장 변수와 비교하여 게임 매니저의 점수가 변경되었다면
	# 점수 라벨 업데이트
