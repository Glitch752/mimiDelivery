extends Control

@export var item_row_scene: PackedScene
@export var row_holder: VBoxContainer

var item_rows: Dictionary[Item, InventoryRow]


func _ready() -> void:
    InventoryItems.item_count_changed.connect(update_item_count)
    
    for item in InventoryItems.ITEMS:
        InventoryItems.items[item] = 0


func update_item_count(item: Item) -> void:
    if InventoryItems.items[item] == 0:
        if item in item_rows:
            item_rows[item].queue_free()
            item_rows.erase(item)
    elif item not in item_rows:
        var item_row: InventoryRow = item_row_scene.instantiate()
        item_row.name_label.text = item.item_name
        item_row.texture_rect.texture = item.texture
        item_row.count_label.text = str(InventoryItems.items[item])
        item_rows[item] = item_row
        row_holder.add_child(item_row)
    else:
        item_rows[item].count_label.text = str(InventoryItems.items[item])
