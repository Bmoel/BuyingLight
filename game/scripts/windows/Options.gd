extends Popup

onready var resolutionDropdown: OptionButton = $Overarching/DisplayContainer/Display/ResolutionChoice/resOptions;

const RES_OPTIONS = [
	Vector2(1280, 720),
	Vector2(1920,1080)
];

func _ready():
	var idx: int = 0;
	for res in RES_OPTIONS:
		var resStr: String = str(res.x) + ' x ' + str(res.y);
		resolutionDropdown.add_item(resStr, idx);
		idx += 1;

func _on_MasterVol_value_changed(value: float):
	OptionsService.update_volume(OptionsService.MASTER_VOLUME,value);

func _on_MusicVol_value_changed(value: float):
	OptionsService.update_volume(OptionsService.MASTER_VOLUME,value);

func _on_SFXVol_value_changed(value: float):
	OptionsService.update_volume(OptionsService.SFX_VOLUME,value);

func _on_isFullscreen_toggled(button_pressed: bool):
	OptionsService.set_fullscreen(button_pressed);

func _on_resOptions_item_selected(index: int):
	if !isValidResIndex(index):
		return;
	OptionsService.set_resolution(RES_OPTIONS[index]);

func isValidResIndex(idx: int) -> bool:
	return idx > -1 and idx < len(RES_OPTIONS);
