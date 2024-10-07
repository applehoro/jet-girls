# author: applehoro
# script purposes:
# - handles weapon switching

extends Node3D

var node_weapon = null;

var assets = {
	"smg": preload( "res://objects/player/weapons/test_gun.tscn" ),
	"smg2": preload( "res://objects/player/weapons/test_gun.tscn" ),
};

var action_to_weapon = {
	"weapon_1": "",
	"weapon_2": "smg",
	"weapon_3": "smg2",
	"weapon_4": "",
	"weapon_5": "",
	"weapon_6": "",
	"weapon_7": "",
	"weapon_8": "",
	"weapon_9": "",
	"weapon_0": "",
};

var current_weapon = "";

func _ready() -> void:
	switch_weapon( "" );

func _process( delta: float ) -> void:
	for a in action_to_weapon:
		if( Input.is_action_just_pressed( a ) ):
			switch_weapon( action_to_weapon[ a ] );

func switch_weapon( t ):
	if( current_weapon != t ):
		if( assets.has( t ) ):
			if( node_weapon != null ):
				node_weapon.unequip();
				node_weapon = null;
				current_weapon = "";
				Inventory.switch_weapon( "" );
			
			node_weapon = assets[ t ].instantiate();
			add_child( node_weapon );
			node_weapon.equip();
			current_weapon = t;
			return true;
	return false;
