extends Camera2D
@export var Cursor : Area2D
@export var CursorSprite : Sprite2D
var WindowBaseSize : Vector2 = (Vector2(1152, 648) - Vector2(8,8))
var UsingMKBD : bool = true
func _process(_delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN if not UsingMKBD else Input.MOUSE_MODE_VISIBLE
	if (Input.is_action_pressed("zoom_in") or Input.is_action_pressed("zoom_out")):
		var z_delta = (Input.get_axis("zoom_out", "zoom_in") * _delta) / 512
		zoom = clamp(zoom + Vector2(z_delta, z_delta), Vector2(0.5, 0.5), Vector2(4,4))
	var _cursor_axis : Vector2 = Vector2(Input.get_axis("cursor_left", "cursor_right"), Input.get_axis("cursor_up", "cursor_down"))
	var _camera_movement_axis : Vector2 = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if UsingMKBD: Cursor.global_position = get_global_mouse_position()
	Cursor.position += (_cursor_axis * 8 ) / zoom
	var upper_left = ((-WindowBaseSize / 2)) / zoom
	var bottom_right = ((WindowBaseSize / 2)) / zoom
	Cursor.position = Cursor.position.clamp(upper_left, bottom_right)
	Cursor.scale = (Vector2.ONE / zoom) * 2
	position += _camera_movement_axis * _delta * 512
	zoom = zoom.snappedf(0.25)
func _input(event: InputEvent) -> void:
	if event is InputEventMouse or event is InputEventKey:
		UsingMKBD = true
	if event is InputEventJoypadMotion or event is InputEventJoypadButton:
		UsingMKBD = false
	if event is InputEventMouseMotion:
		var ev = event as InputEventMouseMotion
		if Input.is_action_pressed("camera_move"):
			position -=( ev.screen_relative * 2) / zoom.length()
	if event is InputEventMouseButton:
		var ev = event as InputEventMouseButton
		if (ev.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP):
			zoom = clamp(zoom + Vector2(0.25, 0.25), Vector2(0.5, 0.5), Vector2(4,4))
		if (ev.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN):
			zoom = clamp(zoom - Vector2(0.25, 0.25), Vector2(0.5, 0.5), Vector2(4,4))

		
