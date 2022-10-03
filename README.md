# fleaflet_demo

An example Flutter project demonstrating how to use the [flutter_map library](https://github.com/fleaflet/flutter_map)
with Stadia Maps. This loosely replicates the [clustering example](https://maplibre.org/maplibre-gl-js-docs/example/cluster/)
for MapLibre GL JS.

## Getting Started

You *will* need to set an API key in [main.dart](lib/main.dart) before running the app. You can sign up for a free
Stadia Maps API key via our [Client Dashboard](https://client.stadiamaps.com/). Otherwise, run it like
any other Flutter app.

This project is a starting point for a Flutter application, but is by no means a comprehensive guide
to all there is to know about Flutter Map. Please refer to the project (linked above)
and the following resources for getting started with Flutter.


- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Gotchas

For completeness, this repo includes both raster and vector examples (via a tab bar).
However, note that the vector tile rendering is performed via a plugin which is still
experimental, and does not support advanced styling features present in many Stadia Maps
styles. Additionally, rotation on macOS may be inverted. See
[this PR for details](https://github.com/flutter/engine/pull/36444); it will be fixed in an upcoming Flutter release.
