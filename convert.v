/*
 * Conversion between color models.
 */

module colors

import math

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

	r := round_int((r1 + m) * 255)
	g := round_int((g1 + m) * 255)
	b := round_int((b1 + m) * 255)

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

	r := round_int(r1 * 255)
	g := round_int(g1 * 255)
	b := round_int(b1 * 255)

	return RGB { r, g, b }
}
