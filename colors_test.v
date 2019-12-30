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
			hex: 0xFF7D0A
		},
		TestItem {
			rgb: colors.RGB { 125, 255, 10 }
			hsl: colors.HSL { 92, 1.00, 0.52 }
			hsv: colors.HSV { 92, 0.961, 1.0 },
			hex: 0x7DFF0A
		},
		TestItem {
			rgb: colors.RGB { 10, 125, 255 }
			hsl: colors.HSL { 212, 1.00, 0.52 }
			hsv: colors.HSV { 212, 0.961, 1.0 }
			hex: 0x0A7DFF
		},
		TestItem {
			rgb: colors.RGB { 50, 100, 150 }
			hsl: colors.HSL { 210, 0.50, 0.392 }
			hsv: colors.HSV { 210, 0.667, 0.588 }
			hex: 0x326496
		}
	]
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
	for item in items_to_test {
		assert item.rgb.hex() == item.hex.hex()
	}
}

fn test_from() {
	for item in items_to_test {
		assert colors.from_hex(item.hex).eq(item.rgb)
	}
}

/*
 * Transformation.
 */

fn test_grayscale() {
	val := colors.RGB { 123, 12, 89 }
	gray := colors.RGB { 54, 54, 54 }

	assert val.grayscale().eq(gray)
}

fn test_lighten_darken() {
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

fn test_transformation_self() {
	for item in items_to_test {
		assert item.hsl.darken(0.1).eq_approx(item.hsl.lighten(-0.1))
		assert item.hsl.saturate(0.1).eq_approx(item.hsl.desaturate(-0.1))
	}
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
