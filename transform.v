/*
 * Transformation.
 */

module colors

import math

enum Channel {
	red green blue
}

// invert inverts a color.
pub fn (val RGB) invert() RGB {
	return RGB {
		r: max_rgb_channel_value - val.r,
		g: max_rgb_channel_value - val.g,
		b: max_rgb_channel_value - val.b
	}
}

// lighten changes lightness of a given HSL struct and returns new struct
pub fn (val HSL) lighten(value f32) HSL {
	l := between(val.l + value, 0, 1)
	return HSL { val.h, val.s, l }
}

// darken changes lightness of a given HSL struct and returns new struct
pub fn (val HSL) darken(value f32) HSL {
	return val.lighten(-value)
}

// saturate changes saturation of a given HSL struct and returns new struct
pub fn (val HSL) saturate(value f32) HSL {
	s := between(val.s + value, 0, 1)
	return HSL { val.h, s, val.l }
}

// desaturate changes saturation of a given HSL struct and returns new struct
pub fn (val HSL) desaturate(value f32) HSL {
	return val.saturate(-value)
}

// rotate changes hue of a given HSL struct and returns new struct
pub fn (val HSL) rotate(degrees int) HSL {
	h := int(math.abs(val.h + degrees)) % 360
	return HSL { h, val.s, val.l }
}
