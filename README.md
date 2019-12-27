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

```
HSL: { H: 83, S: 0.764706, L: 0.333333 }
HSV: { H: 83, S: 0.866667, V: 0.588235 }
```

For more details see `colors.v` file.
