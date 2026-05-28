func type_rich_text(label: RichTextLabel, text: String, typing_speed: float = 30.0, start_delay: float = 0.2):
	label.visible_characters = 0
	label.text = text

	if start_delay > 0.0:
		await get_tree().create_timer(start_delay).timeout

	var visible_count := 0.0
	var total_characters := label.get_total_character_count()

	while visible_count < total_characters:
		visible_count += typing_speed * get_process_delta_time()
		label.visible_characters = int(visible_count)
		await get_tree().process_frame

	label.visible_characters = -1
