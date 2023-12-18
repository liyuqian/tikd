import 'package:tikd/base.dart';
import 'package:tikd/style.dart';
import 'package:vector_math/vector_math_64.dart';

class TikzPicture {
  TikzPicture({List<StyleOption> options = const []}) : _options = options;

  static const String kBegin = r'\begin{tikzpicture}';
  static const String kEnd = r'\end{tikzpicture}';

  void draw(RawElement element, {List<StyleOption> options = const []}) =>
      drawRaw(element.toRaw(), options: options);
  void drawRaw(String raw, {List<StyleOption> options = const []}) {
    final String opt = options.isEmpty ? '' : '[${options.join(', ')}]';
    _lines.add('\\draw$opt $raw;');
  }

  void addRaw(String raw) => _lines.add(raw);
  void addStyle(CustomStyle style) => _customStyles.add(style);

  List<String> buildLines() => [
        '[',
        ..._options.map((o) => '  ${o.toRaw()},'),
        ..._customStyles.map((s) => '  ${s.toRaw()},'),
        ']',
        ..._lines,
      ];

  final List<StyleOption> _options;
  final List<CustomStyle> _customStyles = [];
  final List<String> _lines = [];
}

/// Element with uniform units.
abstract class UnitElement implements RawElement {
  /// The default empty unit is cm in TIKZ.
  UnitElement({this.unit = ""});
  final String unit;

  String uv(double v) => '$v$unit';
  String uxy(Vector2 xy) => '(${uv(xy.x)}, ${uv(xy.y)})';
}

class Lines extends UnitElement {
  Lines(this.points, {super.unit = ""});
  final List<Vector2> points;

  @override
  String toRaw() {
    return points.map((p) => uxy(p)).join(' -- ');
  }
}

class Circle extends UnitElement {
  Circle({required this.center, required this.radius, super.unit = ""});
  final Vector2 center;
  final double radius;

  @override
  String toRaw() {
    return '${uxy(center)} circle [radius=${uv(radius)}]';
  }
}

class Grid extends UnitElement {
  Grid(this.from, this.to, {required this.step, super.unit = ""});
  final Vector2 from;
  final Vector2 to;
  final double step;

  @override
  String toRaw() => '${uxy(from)} grid [step=${uv(step)}] ${uxy(to)}';
}
