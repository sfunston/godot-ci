extends Control


@export var sound_off: Texture

@onready var slider: VSlider = $VBoxContainer/AudioSlider
@onready var ico = $VBoxContainer/SoundIcon
@onready var sound_on = ico.texture

func _ready() -> void:
	slider.value = AudioManager.volume
	_on_audio_slider_value_changed(slider.value)

func _on_audio_slider_value_changed(value: float) -> void:
	ico.texture = sound_off if is_zero_approx(value) else sound_on
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), (10 * log(value)))
	AudioManager.volume = slider.value


func _on_sound_icon_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		slider.value = int(is_zero_approx(slider.value))
		AudioManager.volume = slider.value
