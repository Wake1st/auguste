# Auguste

A Puppet Show Maker.

## Planning

### Prototype

- [x] import
	- [x] textures
	- [x] audio
	- [x] scripts
	- [x] storing files and keeping in RAM
- [ ] editor
	- [x] importing
	- [ ] exporting
	- [ ] scripting
		- [x] commands
		- [ ] breakpoints
		- [ ] step through
- [ ] stage
	- [ ] locations
		- [x] lighting
		- [x] passing actor
		- [ ] sub-locations
	- [ ] debug/follow the script
- [ ] export
	- [ ] scripts
	- [ ] recording

## Keywords

- `scene 'name'`
	- description: defines a scene, displaying a title card
	- required: the `'name'` of a scene
- `wait *duration*`
	- description: delays the scene
	- required: the `duration` of the delay
- `sound 'sound name' [-d *delay*] [-o || [-b *start time*] [-t *duration*] [-c *cycle*]]`
	- description: plays a sound
	- optional: will stop a currenty playing sound with `-o`
	- optional: start at a specific `start time` (default := 0.0)
	- optional: last for a speficic `duration` (default := plays the whole file)
	- optional: loop (default := indefinite)
- `light *type* *rgba(red,green,blue,alpha)* [-o -d *delay*] [-l *location*]`
	- description: illuminates the stage
	- required: `type`, `fresnel` (illuminates the whole stage) or `spot` (illuminates a specific location, hence the optional `location` parameter)
	- required: a color using `rgba` function, with the params `red`,`green`, and `blue` to range from `0-255` and `alpha` to range from `0-1`
	- optional: a delay of `*delay*` seconds, including decimals
- `actor 'name' 'texture'`
	- description: defines a actor
	- required: a `'name'` which will be used to identity the actor
	- required: a texture to visually represent the actor
- `actor: [*action*] ["dialogue"]`
	- description: commands a actor to do and/or say something
	- required: at least one `action` or `"dialogue"` is required, both can be optional
	- optional: an `action` for the actor to perform
	- optional: `"dialogue"` for the actor to "say" (the dialogue will be displayed as subtitles at the bottom of the stage)
	- `enter *location* [-d *from*] [-t *duration*]`
		- description: introduces a actor onto the stage
		- required: `location` on stage to put the actor
		- optional: `from`, the direction from where the actor appears (`below`, `above`, `right`, `left`) (default is `below`)
		- optional: the `duration` which the entrance lasts (default is one second)
	- `exit *location* [-d *to*] [-t *duration*]`
		- description: introduces a actor onto the stage
		- required: `location` on stage to put the actor
		- optional: `to`, the direction to where the actor disappears (`below`, `above`, `right`, `left`) (default is `below`)
		- optional: the `duration` which the exit lasts (default is one second)
	- `move *location* [-s *sub-location*]`
		- required: `location`, a specific place on screen
		- optional: `sub-location`, relative to anything already there
	- `animate 'animation name' [-t *duration* || -c *cycle count*]`:
		- description: animates the actor
		- required: `'animation name'` to specify the type of animation to play
		- optional: a specific time or cycle count (default is one second)

### Actions

Actions can be chained together with the ` | ` actor to allow multiple animations to occur in parallel.

EXAMPLES:

```
alice: move down-center | animate "bounce" -t 3.2 | animate "rock" -c 4
```

### Locations

For this script, the stage locations are divided into a 3x3 grid.

![a 3x3 grid of a stage](https://files.mtstatic.com/site_9956/118016/0?Expires=1754204515&Signature=re~euF7CBDAFU~jnNUy0fXjMUhBOIPL63cF4wXf3-nz31sDdShKW1vNSY~ouxQvOMtT-Q9isU4VxsOA-s7-yl7NvEokxdX31Hb4BGSKyIR2jEEEhk9SshrTcweNhYQ9~gBHuhsak2asyoyZHASvlRtym3bbh0N90IPV6r4kSIYE_&Key-Pair-Id=APKAJ5Y6AV4GI7A555NA)

- down / center / up: closer to the audience, center of the stage, and furthest from the audience
- left / center / right: the left, center, and right side of the stage according to the audience

There is also the option to provide a sub-location with the `-s` parameter; this will move the actor relative to any other actors in a scene. So if a actor is meant to be `down-center up-center` they will go to the `up-center` part of the `down-center` location.

If a actor(s) are already present in the same `location` and `sub-location`, then the newest actor will be placed in the front.

EXAMPLES:

```
alice: move down-left
bob: move up-right
celeste: move center
alice: move up-center, center
```

### Animation

There is a list of default animations to choose from; these are kept simple for easy of understanding - more complexe animations can be made by chaining together multiple simple ones.

The default duration for an animation is one second; this duration can be modified by either setting a specific time with the `-t` parameter (followed by the length in time, as a float) or by using the `-c` parameter (followed by the number of cycles, as a int).

EXAMPLES:

```
alice: animate "bounce"
bob: animate "bounce" -t 2.3
celeste: animate "bounce" -c 3
```

## Blog

### 8/6/2025

After some initial setup of importing assets and a basic stage, I have begun work on the \
script interpreter. I'm thinking of turning these strings into `Commands`, \
wherein each command can be utilized via data instead of constant string checking.
