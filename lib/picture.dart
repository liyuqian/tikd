import 'package:tikd/base.dart';
import 'package:tikd/style.dart';
import 'package:vector_math/vector_math_64.dart';

class TikzPicture {
  TikzPicture({List<StyleOption> options = const []}) : _options = options;

  static const String kBegin = r'\begin{tikzpicture}';
  static const String kEnd = r'\end{tikzpicture}';

  void draw(RawElement element) => drawRaw(element.toRaw());
  void drawRaw(String raw) => _lines.add(r'\draw ' '$raw;');

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

  String uu(double v) => '$v$unit';
}

class Lines extends UnitElement {
  /// [coordinates] is n x 2: a list of n number of (x, y).
  Lines(List<List<double>> coordinates, {super.unit = ""})
      : points = coordinates.map((c) => Vector2(c[0], c[1])).toList();

  final List<Vector2> points;

  @override
  String toRaw() {
    return points.map((p) => '(${uu(p.x)}, ${uu(p.y)})').join(' -- ');
  }
}

class Line extends Lines {
  Line(List<double> p1, List<double> p2, {String unit = ""})
      : super([p1, p2], unit: unit);
}

class Circle extends UnitElement {
  Circle({
    required double x,
    required double y,
    required double r,
    super.unit = "",
  })  : center = Vector2(x, y),
        radius = r;

  final Vector2 center;
  final double radius;

  @override
  String toRaw() {
    return '(${uu(center.x)}, ${uu(center.y)}) circle [radius=${uu(radius)}]';
  }
}
