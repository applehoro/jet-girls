# author: applehoro
# script purposes:
# - store references to some nodes (player and world)
# - store game settings and send signal on their change
# - hande 3d raycasting by code


extends Node

var node_world = null;
var node_player = null;

var settings = {
	"mouse_sensitivity": 0.005,
	
	"vsync": true,
	"aa": false,
	"render_distance": 2000.0,
	"fov": 60.0,
	"smoke_trails": true,
	"water_effects": true,
	"outline": true,
	"lens_flare": true,
	"special_effects": true,
};
signal on_update_settings();

@export_flags_3d_physics var water_layer = 0b00000000_00000000_00000000_00000010;

func _ready() -> void:
	update_settings();

# raycasting
func raycast_3d( from, to, exclude = [], mask = 0xFFFFFFFF ):
	var space_state = node_world.get_world_3d().direct_space_state;
	var query = PhysicsRayQueryParameters3D.create( from, to );
	query.exclude = exclude;
	query.collision_mask = mask;
	return space_state.intersect_ray( query );

func raycast_3d_area( from, to, exclude = [], mask = 0xFFFFFFFF ):
	var space_state = node_world.get_world_3d().direct_space_state;
	var query = PhysicsRayQueryParameters3D.create( from, to );
	query.exclude = exclude;
	query.collision_mask = mask;
	query.collide_with_areas = true;
	query.collide_with_bodies = false;
	return space_state.intersect_ray( query );

# settings
func update_settings():
	settings = {
		"mouse_sensitivity": Config.get_config( "InputSettings", "MouseSensitivity" )*0.01,
		
		"vsync": Config.get_config( "VideoSettings", "VSync" ),
		"aa": Config.get_config( "VideoSettings", "Aa" ),
		"render_distance": 2000.0 + Config.get_config( "VideoSettings", "RenderDistance" )*8000.0,
		"fov": 60.0 + Config.get_config( "VideoSettings", "Fov" )*40.0,
		"smoke_trails": Config.get_config( "VideoSettings", "SmokeTrails" ),
		"water_effects": Config.get_config( "VideoSettings", "WaterEffects" ),
		"outline": Config.get_config( "VideoSettings", "Outline" ),
		"lens_flare": Config.get_config( "VideoSettings", "LensFlare" ),
		"special_effects": Config.get_config( "VideoSettings", "SpecialEffects" ),
	};
	
	if( settings[ "aa" ] ):
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA;
	else:
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED;
	
	if( settings[ "vsync" ] ):
		DisplayServer.window_set_vsync_mode( DisplayServer.VSYNC_ENABLED );
	else:
		DisplayServer.window_set_vsync_mode( DisplayServer.VSYNC_DISABLED );
	
	emit_signal( "on_update_settings" );

