var container_tweens := {}


func set_pivot_without_moving(control: Control, new_pivot: Vector2):
	var old_pivot := control.pivot_offset
	var visual_position := control.position + old_pivot * (Vector2.ONE - control.scale)

	control.pivot_offset = new_pivot
	control.position = visual_position - new_pivot * (Vector2.ONE - control.scale)


func get_animatable_children(container: Control) -> Array[Control]:
	var animatable_children: Array[Control] = []

	for child in container.get_children():
		if child is Control:
			# supports wrapper Controls containing actual UI elements
			if child.get_child_count() > 0 and child.get_child(0) is Control:
				animatable_children.append(child.get_child(0))
			else:
				animatable_children.append(child)

	return animatable_children


func animate_container_children(container: Control, settings := {}):
	var anim_type: String = settings.get("anim_type", "scale")
	var order_type: String = settings.get("order_type", "top_to_bottom")
	var pivot: String = settings.get("pivot", "center")
	var duration: float = settings.get("duration", 0.3)
	var delay_appear: float = settings.get("delay_appear", 0.5)
	var delay_between_elements: float = settings.get("delay_between_elements", 0.08)

	var children := get_animatable_children(container)

	if order_type == "bottom_to_top":
		children.reverse()

	if container_tweens.has(container) and container_tweens[container].is_running():
		container_tweens[container].kill()

	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	container_tweens[container] = tween
	tween.set_parallel(true)

	for i in children.size():
		var child := children[i]
		var delay := delay_appear + delay_between_elements * i

		child.modulate.a = 0.0

		match pivot:
			"center":
				set_pivot_without_moving(child, child.size / 2.0)

			"top_left":
				set_pivot_without_moving(child, Vector2.ZERO)

			"top_center":
				set_pivot_without_moving(
					child,
					Vector2(child.size.x / 2.0, 0.0)
				)

		match anim_type:
			"scale":
				var final_scale := child.scale

				child.scale = final_scale * 0.01

				tween.tween_property(child, "scale", final_scale, duration).set_delay(delay)
				tween.tween_property(child, "modulate:a", 1.0, 0.05).set_delay(delay)

			"slide_left":
				var final_x := child.position.x

				child.position.x = final_x - child.size.x

				tween.tween_property(child, "position:x", final_x, duration).set_delay(delay)
				tween.tween_property(child, "modulate:a", 1.0, 0.05).set_delay(delay)

			"slide_right":
				var final_x := child.position.x

				child.position.x = final_x + child.size.x

				tween.tween_property(child, "position:x", final_x, duration).set_delay(delay)
				tween.tween_property(child, "modulate:a", 1.0, 0.05).set_delay(delay)
