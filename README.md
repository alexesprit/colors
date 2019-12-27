# colors

`colors` is a library for conversion between different color models written in V.

## Usage

```v
import colors

fn main() {
    val := colors.RGB { 100, 150, 20 }

    println('HSL: $val.hsl()')
    println('HSV: $val.hsv()')
}
```

For more details see `colors.v` file.
