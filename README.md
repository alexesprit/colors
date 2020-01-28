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

    println(val.hsl())
    println(val.hsv())
}
```

```
hsl(83, 76%, 33%)
hsv(83, 87%, 59%)
```

For more details see `colors.v` file.
