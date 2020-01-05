# colors

A library for color transformation and conversion between different color models written in V.

## Features

 - Functions to convert colors between different color models
 - Functions to compare two instances of a color model
 - Functions to return a string representation of a color model
 - Functions to transform colors

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
