extends Node

signal item_count_changed(item: Item)

const ITEMS: Array[Item] = [
    preload("res://items/blahaj.tres"),
    preload("res://items/durian.tres"),
]

var items: Dictionary[Item, int]


func gain_item(item: Item, amount: int) -> void:
    items[item] += amount
    item_count_changed.emit(item)


func has_item(item: Item, amount: int) -> bool:
    return items[item] >= amount
