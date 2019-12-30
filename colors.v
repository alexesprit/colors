/*
 * This module provides structs represent different color models,
 * and functions to work with models:
 *  - functions to convert values between different models
 *  - functions to compare two instances of a color model
 *  - functions to return a string representation of a color model instance
 */

module colors

import (
	math strconv
)

// Structure representing RGB color model.
pub struct RGB {
pub:
	r int
	g int
	b int
}

// Structure representing HSL color model.
pub struct HSL {
pub:
	h int
	s f32
	l f32
}

// Structure representing HSV color model.
pub struct HSV {
pub:
	h int
	s f32
	v f32
}

/*
 * Constructors.
 */

pub fn from(input int) ?RGB {
	if (input < 0) {
		return error('Negative input: $input')
	}

	r := (input & 0xFF0000) >> 16
	g := (input & 0xFF00) >> 8
	b := (input & 0xFF)

	return RGB { r, g, b }
}

pub fn parse(input string) ?RGB {
	mut raw_value := input
	if raw_value.starts_with('0x') {
		raw_value = raw_value[2..]
	} else if raw_value.starts_with('#') {
		raw_value = raw_value[1..]
	}

	if !is_number(raw_value) {
		return error('Invalid input: $input')
	}

	value := int(strconv.parse_int(raw_value, 16, 0))
	return from(value)
}

/*
 * String representation.
 */

// str returns a string representation of a RGB struct.
pub fn (val RGB) str() string {
	return '{ R: $val.r, G: $val.g, B: $val.b }'
}

// str returns a string representation of a HSL struct.
pub fn (val HSL) str() string {
	return '{ H: $val.h, S: $val.s, L: $val.l }'
}

// str returns a string representation of a HSV struct.
pub fn (val HSV) str() string {
	return '{ H: $val.h, S: $val.s, V: $val.v }'
}

// hex returns a string representation of RGB struct in hexadecimal format.
pub fn (val RGB) hex() string {
	color := (val.r << 16) & 0xFF0000 | (val.g << 8) & 0xFF00 | val.b & 0xFF
	return color.hex()
}

/*
 * Comparison.
 */

// eq_approx checks if a given HSL struct is approximalely equal to a caller.
pub fn (a HSL) eq_approx(b HSL) bool {
	return
		delta_ok(a.h, b.h, HueThreshold) &&
		delta_ok(a.s, b.s, SaturationThreshold) &&
		delta_ok(a.l, b.l, LightnessThreshold)
}

// eq_approx checks if a given HSV struct is approximalely equal to a caller.
pub fn (a HSV) eq_approx(b HSV) bool {
	return
		delta_ok(a.h, b.h, HueThreshold) &&
		delta_ok(a.s, b.s, SaturationThreshold) &&
		delta_ok(a.v, b.v, ValueThreshold)
}

// eq_approx checks if a given RGB struct is approximalely equal to a caller.
pub fn (a RGB) eq_approx(b RGB) bool {
	return
		delta_ok(a.r, b.r, RgbThreshold) &&
		delta_ok(a.g, b.g, RgbThreshold) &&
		delta_ok(a.b, b.b, RgbThreshold)
}

// eq checks if a given HSL struct is equal to a caller.
pub fn (a HSL) eq(b HSL) bool {
	return a.h == b.h && a.s == b.s && a.l == b.l
}

// eq checks if a given HSV struct is equal to a caller.
pub fn (a HSV) eq(b HSV) bool {
	return a.h == b.h && a.s == b.s && a.v == b.v
}

// eq checks if a given RGB struct is equal to a caller.
pub fn (a RGB) eq(b RGB) bool {
	return a.r == b.r && a.g == b.g && a.b == b.b
}

/*
 * Transformation.
 */

pub fn (val RGB) grayscale() RGB {
	gray :=
		round_int(f32(val.r) * 0.299) +
		round_int(f32(val.g) * 0.587) +
		round_int(f32(val.b) * 0.114)

	return RGB { gray, gray, gray }
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

/*
 * RGB section.
 */

// hsl converts RGB to HSL.
pub fn (val RGB) hsl() HSL {
	r := f32(val.r) / 255
	g := f32(val.g) / 255
	b := f32(val.b) / 255

	max := max_value(r, g, b)
	min := min_value(r, g, b)
	delta := max - min

	l := (max + min) / 2
	mut s := f32(0)
	mut h := 0

	if delta == 0 {
		s = 0
	} else {
		s = delta / (1.0 - math.abs(max + min - 1))
	}

	if delta == 0 {
		h = 0
	} else if max == r {
		h = round_int(60.0 * (g - b) / delta)
		if (g < b) {
			h += 360
		}
	} else if max == g {
		h = round_int(60.0 * (b - r) / delta) + 120
	} else if max == b {
		h = round_int(60.0 * (r - g) / delta) + 240
	}

	return HSL{ h, s, l }
}

// hsl converts RGB to HSV.
pub fn (val RGB) hsv() HSV {
	r := f32(val.r) / 255
	g := f32(val.g) / 255
	b := f32(val.b) / 255

	max := max_value(r, g, b)
	min := min_value(r, g, b)
	delta := max - min

	v := max
	mut s := f32(0)
	mut h := 0

	if max == 0 {
		s = 0.0
	} else {
		s = 1.0 - (min / max)
	}

	if delta == 0 {
		h = 0
	} else if max == r {
		h = round_int(60.0 * (g - b) / delta)
		if (g < b) {
			h += 360
		}
	} else if max == g {
		h = round_int(60.0 * (b - r) / delta) + 120
	} else if max == b {
		h = round_int(60.0 * (r - g) / delta) + 240
	}

	return HSV { h, s, v }
}

/*
 * HSL section.
 */

// hsl converts HSL to RGB.
pub fn (val HSL) rgb() RGB {
	c := (1.0 - math.abs(2.0 * val.l - 1.0)) * val.s
	h := f32(val.h) / 60.0
	x := c * (1.0 - math.abs(math.fmod(h, 2.0) - 1.0))

	mut r1 := 0.0
	mut g1 := 0.0
	mut b1 := 0.0

	hi := (val.h / 60) % 6
	match hi {
		0 {
			r1 = c
			g1 = x
			b1 = 0.0
		}
		1 {
			r1 = x
			g1 = c
			b1 = 0.0
		}
		2 {
			r1 = 0.0
			g1 = c
			b1 = x
		}
		3 {
			r1 = 0.0
			g1 = x
			b1 = c
		}
		4 {
			r1 = x
			g1 = 0.0
			b1 = c
		}
		5 {
			r1 = c
			g1 = 0.0
			b1 = x
		}
		else {}
	}

	m := val.l - c / 2.0

	r := round_int((r1 + m) * 255.0)
	g := round_int((g1 + m) * 255.0)
	b := round_int((b1 + m) * 255.0)

	return RGB { r, g, b }
}

// hsl converts HSL to RGB.
pub fn (val HSL) hsv() HSV {
	s1 := val.s * (if val.l < 0.5 { val.l } else { 1.0 - val.l })

	h := val.h
	v := val.l + s1
	s := 2.0 * s1 / (val.l + s1)

	return HSV { h, s, v }
}

/*
 * HSV section.
 */

// hsl converts HSV to HSL.
pub fn (val HSV) hsl() HSL {
	h := val.h
	l := (2.0 - val.s) * val.v / 2.0
	mut s := 0.0

	if l != 0 {
	    if l == 1 {
            s = 0
        } else if l < 0.5 {
            s = val.s * val.v / (l * 2.0)
        } else {
            s = val.s * val.v / (2.0 - l * 2.0)
        }
	}

	return HSL { h, s, l }
}

// rgb converts HSV to HSL.
pub fn (val HSV) rgb() RGB {
	v := val.v
	hi := (val.h / 60) % 6
	vmin := (1.0 - val.s) * v
	a := (v - vmin) * (val.h % 60) / 60.0
	vinc := vmin + a
	vdec := v - a

	mut r1 := 0.0
	mut g1 := 0.0
	mut b1 := 0.0

	match hi {
		0 {
			r1 = v
			g1 = vinc
			b1 = vmin
		}
		1 {
			r1 = vdec
			g1 = v
			b1 = vmin
		}
		2 {
			r1 = vmin
			g1 = v
			b1 = vinc
		}
		3 {
			r1 = vmin
			g1 = vdec
			b1 = v
		}
		4 {
			r1 = vinc
			g1 = vmin
			b1 = v
		}
		5 {
			r1 = v
			g1 = vmin
			b1 = vdec
		}
		else {}
	}

	r := round_int(r1 * 255.0)
	g := round_int(g1 * 255.0)
	b := round_int(b1 * 255.0)

	return RGB { r, g, b }
}

/*
 * Private constants and functions.
 */

const (
	HueThreshold = 1
	SaturationThreshold = 0.001
	LightnessThreshold = 0.001
	ValueThreshold = 0.002
	RgbThreshold = 1
)

fn max_value(a, b, c f64) f64 {
	return math.max(math.max(a, b), c)
}

fn min_value(a, b, c f64) f64 {
	return math.min(math.min(a, b), c)
}

fn between(a, min, max f64) f64 {
	return math.min(math.max(a, min), max)
}

fn round_int(value f64) int {
	return int(math.round(value))
}

fn delta_ok(a, b, threshold f64) bool {
	return math.abs(a - b) <= threshold
}

fn is_number(input string) bool {
	for c in input {
		if !c.is_hex_digit() {
			return false
		}
	}

	return true
}
