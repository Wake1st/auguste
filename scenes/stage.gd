class_name Stage
extends Node2D


enum Location {
	UP_LEFT,
	UP_CENTER,
	UP_RIGHT,
	LEFT,
	CENTER,
	RIGHT,
	DOWN_LEFT,
	DOWN_CENTER,
	DOWN_RIGHT
}

enum Direction {
	BELOW,
	ABOVE,
	RIGHT,
	LEFT,
}

enum Light {
	SPOT,
	FRESNEL,
}

enum Animations {
	BOUNCE,
	WOBBLE,
	ROCK,
	SPIN,
}
