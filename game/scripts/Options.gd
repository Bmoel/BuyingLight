extends Popup

#CONSTANTS
const MIN_VOLUME = -20
const MASTER_VOLUME = 0 
const MUSIC_VOLUME = 1 
const SFX_VOLUME = 2

#GLOBALS
var master_vol = 500
var music_vol = 500
var sfx_vol = 500

func _on_MasterVol_value_changed(value):
	update_volume(MASTER_VOLUME,value);


func _on_MusicVol_value_changed(value):
	update_volume(MASTER_VOLUME,value);


func _on_SFXVol_value_changed(value):
	update_volume(SFX_VOLUME,value);

"""
* Pre: one of the volume sliders was changed
* Post: Volume is changed depending on value
* Params: bus_idx (index of audio bus to change)
		  value (value of slider)
* Return: None
"""
func update_volume(bus_idx, value) -> void:
	var was_mute = false #variable to tell if volume was muted and needs to be changed
	###########################################################################
	#Set audio bus and save data to file
	AudioServer.set_bus_volume_db(bus_idx,value)
	if bus_idx == 0:
		if master_vol == MIN_VOLUME:
			was_mute = true
		master_vol = value
	elif bus_idx == 1:
		if music_vol == MIN_VOLUME:
			was_mute = true
		music_vol = value
	elif bus_idx == 2:
		if sfx_vol == MIN_VOLUME:
			was_mute = true
		sfx_vol = value
	###########################################################################
	# if the value is a min, mute the bus
	if value == MIN_VOLUME:
		AudioServer.set_bus_mute(bus_idx, not AudioServer.is_bus_mute(bus_idx))
	# if the previous value was a min and now isn't, unmute the bus
	if was_mute and value != MIN_VOLUME:
		AudioServer.set_bus_mute(bus_idx, false)
