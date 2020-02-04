/*
 * Comparison.
 */

module colors

const (
	HueThreshold = 1
	SaturationThreshold = 0.001
	LightnessThreshold = 0.001
	ValueThreshold = 0.001
	RgbThreshold = 1
)

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

// eq_rgb_gx checks if a given RGB and gx.Color structures are equal.
pub fn eq_rgb_gx(a RGB, b gx.Color) bool {
	return a.r == b.r && a.g == b.g && a.b == b.b
}
