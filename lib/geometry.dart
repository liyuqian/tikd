import 'package:tikd/base.dart';
import 'package:tikd/style.dart';
import 'package:vector_math/vector_math_64.dart';

/// Geometry with uniform units.
abstract class Geometry extends RawElement {
  /// The default empty unit is cm in TIKZ.
  Geometry({this.unit = ""});
  final String unit;

  Node? node;

  /// A reference to the coordinate of the geometry.
  Coordinate? coordinate;

  /// The description (to be overriden) except the node and the coordinate.
  String get description;

  @override
  String toRaw() => '$description ${str(node)}';

  String uv(double v) => '$v$unit';
  String uxy(Vector2 xy) => '(${uv(xy.x)}, ${uv(xy.y)})';
}

enum Placement { above, below, left, right }

class Node extends RawElement {
  Node({
    this.place,
    List<StyleOption> options = const [],
    this.content = '',
  }) : _options = options;
  final List<StyleOption> _options;
  final Placement? place;
  final String content;

  @override
  String toRaw() => 'node[$_allOptions] {$content}';

  String get _allOptions => [
        ...place == null ? [] : [place!.name],
        ..._options
      ].join(', ');
}

class Coordinate extends RawElement {
  Coordinate(this.name);
  final String name;

  @override
  String toRaw() => 'coordinate($name)';
}

class Lines extends Geometry {
  Lines(this.points, {super.unit = ""});
  final List<Vector2> points;

  @override
  String get description => points.map((p) => uxy(p)).join(' -- ');
}

class Circle extends Geometry {
  Circle({required this.center, required this.radius, super.unit = ""});
  final Vector2 center;
  final double radius;

  @override
  String get description => '${uxy(center)} circle [radius=${uv(radius)}]';
}

class Grid extends Geometry {
  Grid(this.from, this.to, {required this.step, super.unit = ""});
  final Vector2 from;
  final Vector2 to;
  final double step;

  @override
  String get description => '${uxy(from)} grid [step=${uv(step)}] ${uxy(to)}';
}
