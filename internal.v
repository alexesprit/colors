/*
 * Private constants and functions.
 */

module colors

import math

const (
	max_rgb_channel_value = 255
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

fn to_percent(value f32) string {
	percent := round_int(value * 100)
	return '$percent%'
}

fn rgb_to_float(rgb RGB) (f32, f32, f32) {
	return
		f32(rgb.r) / max_rgb_channel_value,
		f32(rgb.g) / max_rgb_channel_value,
		f32(rgb.b) / max_rgb_channel_value
}
