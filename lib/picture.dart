import 'package:tikd/base.dart';
import 'package:tikd/path.dart';
import 'package:tikd/style.dart';

class Picture extends Section {
  Picture({List<StyleOption> options = const []}) : super(options: options);

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

abstract class Section extends Referable {
  Section({List<StyleOption> options = const []}) : _options = options;

  String get begin;
  String get end;

  void draw(Referable element, {List<StyleOption> options = const []}) =>
      _add(r'\draw', options, element.definition);
  void fill(Referable element, {List<StyleOption> options = const []}) =>
      _add(r'\fill', options, element.definition);
  void filldraw(Referable element, {List<StyleOption> options = const []}) =>
      _add(r'\filldraw', options, element.definition);
  void namePath(Path p, String name) =>
      _add(r'\path', [StringOption('name path=$name')], p.definition);

  void addRaw(String raw) => _elements.add(RawString(raw));
  void addStyle(CustomStyle style) => _customStyles.add(style);
  void addScope(Scope scope) => _elements.add(scope);

  void _add(String command, List<StyleOption> options, String raw) =>
      _elements.add(RawString('$command${joinOptions(options)} $raw;'));

  @override
  List<String> toLines() => [begin, ...indent(buildLines()), end];

  @override
  String get definition => toLines().join('\n');

  List<String> buildLines() {
    List<String> lines = [
      '[',
      ..._options.map((o) => '  ${o.reference},'),
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
  final List<Referable> _elements = [];
}
