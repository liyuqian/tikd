import 'package:tikd/base.dart';
import 'package:tikd/style.dart';

class TikzPicture extends Section {
  TikzPicture({List<StyleOption> options = const []}) : super(options: options);

  @override
  String get begin => r'\begin{tikzpicture}';
  @override
  String get end => r'\end{tikzpicture}';
}

class Scope extends Section {
  Scope({List<StyleOption> options = const []}) : super(options: options);

  @override
  String get begin => r'\begin{scope}';
  @override
  String get end => r'\end{scope}';
}

abstract class Section extends RawElement {
  Section({List<StyleOption> options = const []}) : _options = options;

  String get begin;
  String get end;

  void draw(RawElement element, {List<StyleOption> options = const []}) =>
      drawRaw(element.toRaw(), options: options);
  void drawRaw(String raw, {List<StyleOption> options = const []}) {
    final String opt = options.isEmpty ? '' : '[${options.join(', ')}]';
    _elements.add(RawString('\\draw$opt $raw;'));
  }

  void addRaw(String raw) => _elements.add(RawString(raw));
  void addStyle(CustomStyle style) => _customStyles.add(style);

  void addScope(Scope scope) => _elements.add(scope);

  @override
  List<String> toLines() => [begin, ...indent(buildLines()), end];

  @override
  toRaw() => toLines().join('\n');

  List<String> buildLines() {
    List<String> lines = [
      '[',
      ..._options.map((o) => '  ${o.toRaw()},'),
      ..._customStyles.map((s) => '  ${s.definition},'),
      ']',
    ];
    for (final element in _elements) {
      lines.addAll(element.toLines());
    }
    return lines;
  }

  final List<StyleOption> _options;
  final List<CustomStyle> _customStyles = [];
  final List<RawElement> _elements = [];
}
