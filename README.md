# colors [![Latest version][version-badge]][version-url] [![Workflow status][workflow-badge]][workflow-url]

A library for color transformation and conversion between different color models written in V.

## Features

-   Functions to convert colors between different color models
-   Functions to compare two instances of a color model
-   Functions to return a string representation of a color model
-   Functions to transform colors

## Installation

You can install this module using the following command:

```sh
# Install via `vpm`
> v install alexesprit.colors

# Install via `vpkg`
> vpkg get colors
```

## Usage

```v
import alexesprit.colors

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

For more details see the [documentation][docs].

## License

Licensed under the [MIT License](LICENSE.md).

[docs]: https://alexesprit.com/colors/
[version-badge]: https://img.shields.io/github/v/release/alexesprit/colors?logo=github&logoColor=white
[version-url]: https://github.com/alexesprit/colors/releases/latest
[workflow-badge]: https://img.shields.io/github/workflow/status/alexesprit/colors/Test?label=test&logo=github&logoColor=white
[workflow-url]: https://github.com/alexesprit/colors/actions?query=workflow%3ATest
