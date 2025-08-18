class_name Errors


enum Types {
	ACTION_NOT_RECOGNISED,
	PARAM_NOT_RECOGNISED,
	ACTOR_NOT_RECOGNISED,
	TEXTURE_NOT_RECOGNISED,
	SOUND_NOT_RECOGNISED,
	ANIMATION_NOT_RECOGNISED,
	LOCATION_NOT_RECOGNISED,
	DIRECTION_NOT_RECOGNISED,
	INVALID_NUMBER,
}

static var messages: Dictionary[Types, String] = {
	Types.ACTION_NOT_RECOGNISED: "'%' is not an action.",
	Types.PARAM_NOT_RECOGNISED: "'%' is not a param for '%'.",
	Types.ACTOR_NOT_RECOGNISED: "Cannot find actor '%'.",
	Types.TEXTURE_NOT_RECOGNISED: "Cannot find texture '%'.",
	Types.SOUND_NOT_RECOGNISED: "Cannot find sound '%'.",
	Types.ANIMATION_NOT_RECOGNISED: "'%' is not an animation.",
	Types.LOCATION_NOT_RECOGNISED: "'%' is not a location.",
	Types.DIRECTION_NOT_RECOGNISED: "'%' is not a direction.",
	Types.INVALID_NUMBER: "'%' is not a valid number.",
}

static var suggestions: Array[String] = [
	"-Check the spelling.",
	"-Refer to the documentation.",
	"-Reach out for support."
]


static func get_message(type: Types, args: Array[String]) -> String:
	return messages[type] % args
