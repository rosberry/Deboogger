# Deboogger
Debug screen for your apps.

<p align="center">
	<img src=".github/example.png" alt="Deboogger" />
</p>

## Usage

```swift
Deboogger.configure(with:
    SwitchTestPlugin(),
    SliderTestPlugin(),
    SegmentTestPlugin(),
    ButtonTestPlugin()
)

Deboogger.configure(with:
    Section(title: "Section 1", plugins: SwitchTestPlugin(), SliderTestPlugin()),
    Section(title: "Section 2", plugins: SegmentTestPlugin(), ButtonTestPlugin())
)
```

## Installation

### Carthage:
```
github "rosberry/Deboogger"
```

## About

<img src="https://github.com/rosberry/Foundation/blob/master/Assets/full_logo.png?raw=true" height="100" />

This project is owned and maintained by [Rosberry](http://rosberry.com). We build mobile apps for users worldwide 🌏.

Check out our [open source projects](https://github.com/rosberry), read [our blog](https://medium.com/@Rosberry) or give us a high-five on 🐦 [@rosberryapps](http://twitter.com/RosberryApps).

## License

Deboogger is available under the MIT license. See the LICENSE file for more info.
