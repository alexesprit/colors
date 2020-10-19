module colors

import math

const (
	max_rgb_channel_value = 255
)

fn max_value(a f64, b f64, c f64) f64 {
	return math.max(math.max(a, b), c)
}

fn min_value(a f64, b f64, c f64) f64 {
	return math.min(math.min(a, b), c)
}

fn between(a f64, min f64, max f64) f64 {
	return math.min(math.max(a, min), max)
}

fn round_int(value f64) int {
	return int(math.round(value))
}

fn delta_ok(a f64, b f64, threshold f64) bool {
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

fn to_percent(value f64) string {
	percent := round_int(value * 100)
	return '$percent%'
}

fn rgb_to_float(rgb RGB) (f64, f64, f64) {
	return f64(rgb.r) / max_rgb_channel_value, f64(rgb.g) / max_rgb_channel_value, f64(rgb.b) /
		max_rgb_channel_value
}

fn float_to_rgb(r f64, g f64, b f64) RGB {
	return RGB{round_int(r * max_rgb_channel_value), round_int(g * max_rgb_channel_value), round_int(b *
		max_rgb_channel_value)}
}

fn calc_yiq_y(val RGB) f64 {
	return 0.299 * f64(val.r) + 0.587 * f64(val.g) + 0.114 * f64(val.b)
}
