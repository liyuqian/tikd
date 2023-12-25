Tools for writing [TIKZ][1] with modern programming supports from Dart, such as
IDE code completion, error highlights, autocorrection, and real-time watch
compilations from TIKZ to SVG.

# Use `tikd` library

Add the following dependency to the `pubspec.yaml`.
```
dependencies:
  tikd:
    git: https://github.com/liyuqian/tikd
```

# Install and use `tikd` tool

```
dart pub global activate -s git https://github.com/liyuqian/tikd
```

```
dart pub global run tikd
```

[1]: https://pgf-tikz.github.io/
