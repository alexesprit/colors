import colors
import gx
import math

struct TestItem {
	gx gx.Color
	rgb colors.RGB
	hsl colors.HSL
	hsv colors.HSV
}

struct ContrastTestItem {
	color colors.RGB
	score string
}

const (
	items_to_test = [
		TestItem {
			gx: gx.Color { 255, 125, 10 }
			rgb: colors.RGB { 255, 125, 10 }
			hsl: colors.HSL { 28, 1.0, 0.52 }
			hsv: colors.HSV { 28, 0.961, 1.0 }
		},
		TestItem {
			gx: gx.Color { 125, 255, 10 }
			rgb: colors.RGB { 125, 255, 10 }
			hsl: colors.HSL { 92, 1.00, 0.52 }
			hsv: colors.HSV { 92, 0.961, 1.0 },
		},
		TestItem {
			gx: gx.Color { 10, 125, 255 }
			rgb: colors.RGB { 10, 125, 255 }
			hsl: colors.HSL { 212, 1.00, 0.52 }
			hsv: colors.HSV { 212, 0.961, 1.0 }
		},
		TestItem {
			gx: gx.Color { 50, 100, 150 }
			rgb: colors.RGB { 50, 100, 150 }
			hsl: colors.HSL { 210, 0.50, 0.392 }
			hsv: colors.HSV { 210, 0.667, 0.588 }
		}
	]
	contrast_score_to_test = [
		ContrastTestItem {
			color: colors.RGB { 0x59, 0x59, 0x59 },
			score: 'AAA'
		},
		ContrastTestItem {
			color: colors.RGB { 0x75, 0x75, 0x75 },
			score: 'AA'
		},
		ContrastTestItem {
			color: colors.RGB { 0xBB, 0xBB, 0xBB },
			score: 'FAIL'
		}
	]

	color_to_test = colors.RGB { 0xFF, 0x99, 0x33 }
	grayscale_to_test = colors.RGB { 0xAC, 0xAC, 0xAC }
	invert_to_test = colors.RGB { 0x00, 0x66, 0xCC }
	hex_to_test = 0xFF9933
	luminance_to_test = 0.442815
	contrast_ratio_to_test = 2.130618

	white_color = colors.RGB { 0xFF, 0xFF, 0xFF }
	black_color = colors.RGB { 0x00, 0x00, 0x00 }
	light_orange = colors.RGB { 0xFA, 0xA2, 0x3F }
	dark_blue = colors.RGB { 0x39, 0x4C, 0x9A }

	float_compare_threshold = 1e-6
)

fn test_self() {
	for item in items_to_test {
		// RGB
		assert item.rgb.hsl().rgb().eq_approx(item.rgb)
		assert item.rgb.hsv().rgb().eq_approx(item.rgb)

		// HSL
		assert item.hsl.rgb().hsl().eq_approx(item.hsl)
		assert item.hsl.hsv().hsl().eq_approx(item.hsl)

		// HSV
		assert item.hsv.hsl().hsv().eq_approx(item.hsv)
		assert item.hsv.rgb().hsv().eq_approx(item.hsv)

		// gx.Color
		converted_gx := item.rgb.gx()
		assert colors.eq_rgb_gx(item.rgb, converted_gx)

		converted_rgb := colors.rgb_from_gx(item.gx)
		assert colors.eq_rgb_gx(converted_rgb, item.gx)
	}
}

fn test_hex() {
	assert color_to_test.hex() == hex_to_test.hex()
}

fn test_parse() {
	raw_colors := ['FF9933', '#FF9933', '0xFF9933', '#f93']

	for raw_color in raw_colors {
		color := colors.parse(raw_color) or {
			assert false
			continue
		}

		assert color.eq(color_to_test)
	}

	black_color_1 := colors.RGB { 0, 0, 0 }
	black_color_2 := colors.parse('0x000000') or {
		assert false
		return
	}
	assert black_color_1.eq(black_color_2)
}

fn test_parse_invalid() {
	invalid_raw_color := '%FF9933'
	colors.parse(invalid_raw_color) or {
		assert true
		return
	}
	assert false
}

fn test_from() {
	color := colors.from(hex_to_test) or {
		assert false
		return
	}

	assert color.eq(color_to_test)
}

fn test_from_invalid() {
	color := colors.from(-1) or {
		assert true
		return
	}
	assert false
}

fn test_is_dark() {
	assert black_color.is_dark()
	assert dark_blue.is_dark()
}

fn test_is_light() {
	assert white_color.is_light()
	assert light_orange.is_light()
}

fn test_contrast_ratio() {
	contrast_ratio := color_to_test.contrast_ratio(white_color)
	diff := math.abs(contrast_ratio - contrast_ratio_to_test)
	assert diff < float_compare_threshold

	assert black_color.contrast_ratio(white_color) == colors.max_contrast_ratio
	assert white_color.contrast_ratio(white_color) == colors.min_contrast_ratio
}

fn test_contrast_score() {
	for item in contrast_score_to_test {
		assert item.color.contrast_score(white_color) == item.score
	}
}

/*
 * Transformation.
 */

fn test_invert() {
	assert color_to_test.invert().eq(invert_to_test)
	assert black_color.invert().eq(white_color)
	assert white_color.invert().eq(black_color)
}

fn test_grayscale() {
	assert color_to_test.grayscale().eq(grayscale_to_test)
}

fn test_luminance() {
	assert black_color.luminance() == 0.0
	assert white_color.luminance() == 1.0

	diff := math.abs(color_to_test.luminance() - luminance_to_test)
	assert diff < float_compare_threshold
}

fn test_transform() {
	value := 0.05
	color := colors.HSL { 235, 0.85, 0.85 }
	darkened := colors.HSL { 235, 0.85, 0.80 }
	lightened := colors.HSL { 235, 0.85, 0.90 }
	saturated := colors.HSL { 235, 0.90, 0.85 }
	desaturated := colors.HSL { 235, 0.80, 0.85 }

	assert color.darken(value).eq_approx(darkened)
	assert color.lighten(value).eq_approx(lightened)
	assert color.saturate(value).eq_approx(saturated)
	assert color.desaturate(value).eq_approx(desaturated)
}

fn test_transform_self() {
	for item in items_to_test {
		assert item.hsl.darken(0.1).eq_approx(item.hsl.lighten(-0.1))
		assert item.hsl.saturate(0.1).eq_approx(item.hsl.desaturate(-0.1))
	}
}

fn test_rotate() {
	color := colors.HSL { 350, 0.8, 0.8 }
	color_rotated := colors.HSL { 10, 0.8, 0.8 }

	assert color.rotate(20).eq_approx(color_rotated)
	assert color.rotate(-360).eq_approx(color_rotated)
}

/*
 * RGB section.
 */

fn test_rgb_to_hsl() {
	for item in items_to_test {
		val := item.rgb.hsl()
		assert val.eq_approx(item.hsl)
	}
}

fn test_rgb_to_hsv() {
	for item in items_to_test {
		val := item.rgb.hsv()
		assert val.eq_approx(item.hsv)
	}
}

/*
 * HSL section.
 */

fn test_hsl_to_rgb() {
	for item in items_to_test {
		val := item.hsl.rgb()
		assert val.eq_approx(item.rgb)
	}
}

fn test_hsl_to_hsv() {
	for item in items_to_test {
		val := item.hsl.hsv()
		assert val.eq_approx(item.hsv)
	}
}

/*
 * HSV section.
 */

fn test_hsv_to_hsl() {
	for item in items_to_test {
		val := item.hsv.hsl()
		assert val.eq_approx(item.hsl)
	}
}

fn test_hsv_to_rgb() {
	for item in items_to_test {
		val := item.hsv.rgb()
		assert val.eq_approx(item.rgb)
	}
}
