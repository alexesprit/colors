module colors

import math
import strconv

pub const (
	min_contrast_ratio = 1.0
	max_contrast_ratio = 21.0
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
	s f64
	l f64
}

// Structure representing HSV color model.
pub struct HSV {
pub:
	h int
	s f64
	v f64
}

// from returns an RGB color model from an integer representation.
pub fn from(input int) ?RGB {
	if input < 0 {
		return error('Negative input: $input')
	}
	r := (input & 0xFF0000) >> 16
	g := (input & 0xFF00) >> 8
	b := (input & 0xFF)
	return RGB{r, g, b}
}

// parse parses a given string and returns an RGB color model.
pub fn parse(input string) ?RGB {
	mut raw_value := if input.starts_with('0x') {
		input[2..]
	} else if input.starts_with('#') {
		input[1..]
	} else {
		input
	}
	if raw_value.len == 3 && input.starts_with('#') {
		r := raw_value[0].str()
		g := raw_value[1].str()
		b := raw_value[2].str()
		raw_value = '$r$r$g$g$b$b'
	}
	if !is_number(raw_value) {
		return error('Invalid input: $input')
	}
	value := int(strconv.parse_int(raw_value, 16, 0))
	return from(value)
}

// str returns a string representation of a RGB struct.
pub fn (val RGB) str() string {
	return 'rgb($val.r, $val.g, $val.b)'
}

// str returns a string representation of a HSL struct.
pub fn (val HSL) str() string {
	s_percent := to_percent(val.s)
	l_percent := to_percent(val.l)
	return 'hsl($val.h, $s_percent, $l_percent)'
}

// str returns a string representation of a HSV struct.
pub fn (val HSV) str() string {
	s_percent := to_percent(val.s)
	v_percent := to_percent(val.v)
	return 'hsv($val.h, $s_percent, $v_percent)'
}

// hex returns a string representation of RGB struct in hexadecimal format.
pub fn (val RGB) hex() string {
	color := (val.r << 16) & 0xFF0000 | (val.g << 8) & 0xFF00 | val.b & 0xFF
	return color.hex()
}

// is_light checks if a color is dark.
pub fn (val RGB) is_dark() bool {
	y := calc_yiq_y(val)
	return y < 128
}

// is_light checks if a color is light.
pub fn (val RGB) is_light() bool {
	return !val.is_dark()
}

// grayscale returns a grayscale color from a true color.
pub fn (val RGB) grayscale() RGB {
	y := round_int(calc_yiq_y(val))
	return RGB{y, y, y}
}

// luminance returns a relative luminance of a color.
pub fn (val RGB) luminance() f64 {
	r, g, b := rgb_to_float(val)
	channels := [r, g, b]
	mut lum := [0.0, 0.0, 0.0]
	for i, c in channels {
		lum[i] = if c <= 0.03928 { c / 12.92 } else { math.pow((c + 0.055) / 1.055, 2.4) }
	}
	return 0.2126 * lum[Channel.red] + 0.7152 * lum[Channel.green] + 0.0722 * lum[Channel.blue]
}

// contrast_ratio returns a contrast ratio between two colors.
pub fn (a RGB) contrast_ratio(b RGB) f64 {
	a_lum := a.luminance()
	b_lum := b.luminance()
	max_lum := math.max(a_lum, b_lum)
	min_lum := math.min(a_lum, b_lum)
	return (max_lum + 0.05) / (min_lum + 0.05)
}

// contrast_score returns a contrast score between two colors.
pub fn (a RGB) contrast_score(b RGB) string {
	// NOTE: Does not support AAA Large and AA Large scores
	contrast := a.contrast_ratio(b)
	return if contrast >= 7.0 {
		'AAA'
	} else if contrast >= 4.5 {
		'AA'
	} else {
		'FAIL'
	}
}
