import colors

struct TestItem {
	rgb colors.RGB
	hsl colors.HSL
	hsv colors.HSV
	hex int
}

const (
	items_to_test = [
		TestItem {
			rgb: colors.RGB { 255, 125, 10 }
			hsl: colors.HSL { 28, 1.0, 0.52 }
			hsv: colors.HSV { 28, 0.961, 1.0 }
		},
		TestItem {
			rgb: colors.RGB { 125, 255, 10 }
			hsl: colors.HSL { 92, 1.00, 0.52 }
			hsv: colors.HSV { 92, 0.961, 1.0 },
		},
		TestItem {
			rgb: colors.RGB { 10, 125, 255 }
			hsl: colors.HSL { 212, 1.00, 0.52 }
			hsv: colors.HSV { 212, 0.961, 1.0 }
		},
		TestItem {
			rgb: colors.RGB { 50, 100, 150 }
			hsl: colors.HSL { 210, 0.50, 0.392 }
			hsv: colors.HSV { 210, 0.667, 0.588 }
		}
	]

	color_to_test = colors.RGB { 0xFF, 0x99, 0x33 }
	grayscale_to_test = colors.RGB { 0xAC, 0xAC, 0xAC }
	hex_to_test = 0xFF9933
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

	invalid_raw_color := '%FF9933'
	colors.parse(invalid_raw_color) or {
		assert true
		return
	}
}

fn test_from() {
	color := colors.from(hex_to_test) or {
		assert false
		return
	}

	assert color.eq(color_to_test)
}

/*
 * Transformation.
 */

fn test_grayscale() {
	assert color_to_test.grayscale().eq(grayscale_to_test)
}

fn test_transfort() {
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
