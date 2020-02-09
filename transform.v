/*
 * Transformation.
 */

module colors

import math

enum Channel {
	red green blue
}

pub fn (val RGB) grayscale() RGB {
	gray :=
		round_int(0.299 * val.r) +
		round_int(0.587 * val.g) +
		round_int(0.114 * val.b)

	return RGB { gray, gray, gray }
}

pub fn (val RGB) luminance() f32 {
	r, g, b := rgb_to_float(val)
	channels := [r, g, b]
	mut lum := [0.0, 0.0, 0.0]

	for i, c in channels {
		lum[i] = if c <= 0.03928 {
			c / 12.92
		} else {
			math.pow((c + 0.055) / 1.055, 2.4)
		}
	}

	return
		0.2126 * lum[Channel.red] +
		0.7152 * lum[Channel.green] +
		0.0722 * lum[Channel.blue]
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
