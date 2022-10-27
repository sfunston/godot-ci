extends Node2D

@onready var pentagrams : Array = self.get_children()
@onready var item_array : Array = [null, null, null, null, null]
var occupancies: Array = [false, false, false, false, false]


func _process(delta):
	if GameManager.is_day():
		item_array = [null, null, null, null, null]
		occupancies = [false, false, false, false, false]
		var penta_index = 0
		for child in pentagrams:
			if !GameManager.locked_items[penta_index]:
				var areas = pentagrams[penta_index].get_overlapping_areas()
				for area in areas:
					# get parents of areas, to use them as offerings
					var item = area.get_parent()
					if item.is_in_group("Offering") and !item.picked:
						if !occupancies[penta_index]:
							occupancies[penta_index] = true
							item_array[penta_index] = item
							GameManager.item_array[penta_index] = item
							item.position = pentagrams[penta_index].global_position
			else:
				GameManager.item_array[penta_index] = GameManager.item_array[penta_index].duplicate()
				GameManager.item_array[penta_index].locked = true
				child.show_light()
			penta_index += 1
#		GameManager.item_array = item_array
