class_name Player extends CharacterBody2D

@export var moveSpeed : float = 100.0 # @export를 사용하면 인스펙터 창에서 값을 조절
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var state : String = "idle"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left") 
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")  
	if direction.length() > 0: # 방향 입력이 있을 때만
		velocity = direction.normalized() * moveSpeed
	else:
		velocity = Vector2.ZERO # 입력이 없으면 멈춤 (또는 velocity = velocity.move_toward(Vector2.ZERO, some_friction * delta) 와 같이 점진적으로 멈추게 할 수도 있습니다)
	move_and_slide()
	if update_state() == true || set_direction() == true:
		update_animation()

func set_direction() -> bool:
	var new_direction : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	if direction.y == 0:
		new_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_direction = Vector2.UP if direction.y < 0 else Vector2.DOWN
	if new_direction == cardinal_direction:
		return false
	cardinal_direction = new_direction
	sprite_2d.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true
	
	
func update_state() -> bool:
	var new_state : String = "idle" if direction == Vector2.ZERO else "walk"
	if new_state == state:
		return false
	state = new_state
	return true
	
func update_animation() -> void:
	animation_player.play(state + "_" + anim_direction())
	pass

func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
	
