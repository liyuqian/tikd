import 'package:vector_math/vector_math_64.dart';

class TikzPicture {
  static const String kBegin = r'\begin{tikzpicture}';
  static const String kEnd = r'\end{tikzpicture}';

  void drawRaw(String raw) {
    lines.add(r'\draw ' '$raw;');
  }

  void draw(UnitElement element) {
    drawRaw(element.toRaw());
  }

  final List<String> lines = [];
}

/// Element with uniform units.
abstract class UnitElement {
  /// Default unit is empty.
  UnitElement({this.unit = ""});

  final String unit;

  /// Raw string representation of the element.
  String toRaw();

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
