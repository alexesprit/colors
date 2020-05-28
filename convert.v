/*
 * Conversion between color models.
 */

module colors

import gx
import math

/*
 * RGB section.
 */

// hsl converts RGB to HSL.
pub fn (val RGB) hsl() HSL {
	r, g, b := rgb_to_float(val)

	max := max_value(r, g, b)
	min := min_value(r, g, b)
	delta := max - min

	l := (max + min) / 2
	mut h := 0

	s := if delta == 0 {
		0
	} else {
		delta / (1.0 - math.abs(max + min - 1))
	}

	if delta == 0 {
		h = 0
	} else if max == r {
		h = round_int(60.0 * (g - b) / delta)
		if g < b {
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
	r, g, b := rgb_to_float(val)

	max := max_value(r, g, b)
	min := min_value(r, g, b)
	delta := max - min

	v := max
	mut h := 0

	s := if max == 0 {
		0.0
	} else {
		1.0 - (min / max)
	}

	if delta == 0 {
		h = 0
	} else if max == r {
		h = round_int(60.0 * (g - b) / delta)
		if g < b {
			h += 360
		}
	} else if max == g {
		h = round_int(60.0 * (b - r) / delta) + 120
	} else if max == b {
		h = round_int(60.0 * (r - g) / delta) + 240
	}

	return HSV { h, s, v }
}

// gx converts RGB to gx.Color structure.
pub fn (val RGB) gx() gx.Color {
	return gx.Color { r: byte(val.r), g: byte(val.g), b: byte(val.b) }
}

/*
 * HSL section.
 */

// hsl converts HSL to RGB.
pub fn (val HSL) rgb() RGB {
	c := (1.0 - math.abs(2.0 * val.l - 1.0)) * val.s
	h := f64(val.h) / 60.0
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

	return float_to_rgb(r1 + m, g1 + m, b1 + m)
}

// hsl converts HSL to HSV.
pub fn (val HSL) hsv() HSV {
	s1 := val.s * (if val.l < 0.5 { val.l } else { 1.0 - val.l })

	h := val.h
	v := val.l + s1
	s := 2.0 * s1 / (val.l + s1)

	return HSV { h, s, v }
}

// gx converts HSL to gx.Color structure.
pub fn (val HSL) gx() gx.Color {
	return val.rgb().gx()
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
		s = if l == 1 {
			0.0
		} else if l < 0.5 {
			val.s * val.v / (l * 2.0)
		} else {
			val.s * val.v / (2.0 - l * 2.0)
		}
	}

	return HSL { h, s, l }
}

// rgb converts HSV to RGB.
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

	return float_to_rgb(r1, g1, b1)
}

// gx converts HSL to gx.Color structure.
pub fn (val HSV) gx() gx.Color {
	return val.rgb().gx()
}

/*
 * gx.Color section.
 */

// rgb_from_gx converts gx.Color structure to RGB structure.
pub fn rgb_from_gx(c gx.Color) RGB {
	return RGB { r: c.r, g: c.g, b: c.b }
}

// rgb_from_gx converts gx.Color structure to HSL structure.
pub fn hsl_from_gx(c gx.Color) HSL {
	return rgb_from_gx(c).hsl()
}

// rgb_from_gx converts gx.Color structure to HSV structure.
pub fn hsv_from_gx(c gx.Color) HSV {
	return rgb_from_gx(c).hsv()
}
