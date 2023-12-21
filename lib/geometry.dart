import 'dart:math';

import 'package:tikd/base.dart';
import 'package:tikd/style.dart';

double toRadian(double degrees) => degrees * (pi / 180);

abstract class Position extends RawElement {
  String get reference => toRaw(); // Can be overriden.

  StringPosition horizontalVertical(Position other) =>
      StringPosition('({$reference} -| {${other.reference}})');
  StringPosition verticalHorizontal(Position other) =>
      StringPosition('({$reference} |- {${other.reference}})');

  StringPosition operator ~/(Position other) => horizontalVertical(other);
  StringPosition operator >=(Position other) => verticalHorizontal(other);
}

class StringPosition extends Position {
  StringPosition(this.s);
  final String s;

  @override
  String toRaw() => s;
}

class XY extends Position {
  XY(this.x, this.y, {this.unit = ''});
  XY.xx(double x, {String unit = ''}) : this(x, x, unit: unit);
  XY.polar(double degrees, double r, {this.unit = ''})
      : x = r * cos(toRadian(degrees)),
        y = r * sin(toRadian(degrees));

  final double x, y;
  final String unit;

  String get xu => '$x$unit';
  String get yu => '$y$unit';

  Path operator -(PathVerb verb) => Path(this) - verb;

  @override
  String toRaw() => '($xu, $yu)';
}

abstract class PathVerb extends RawElement {
  Node? midNode;
  Node? endNode;
  Coordinate? coordinate;
  List<StyleOption> options = [];

  // To be overriden.
  String get verb;
  List<String> get ends => [];
  List<StyleOption> get specialOptions => [];

  List<StyleOption> get _allOptions => [...options, ...specialOptions];
  String get _opt => joinOptions(_allOptions);

  @override
  String toRaw() => [
        '$verb$_opt',
        ...lstr(midNode),
        ...ends,
        ...lstr(endNode),
        ...lstr(coordinate)
      ].join(' ');
}

abstract class ToVerb extends PathVerb {
  ToVerb(this.end);
  final Position end;

  @override
  List<String> get ends => [end.reference];
}

class MoveTo extends ToVerb {
  MoveTo(super.end);

  @override
  String get verb => '';
}

class LineTo extends ToVerb {
  LineTo(super.end);

  @override
  String get verb => '--';
}

class QuadTo extends ToVerb {
  QuadTo(this.control, super.end);
  XY control;

  @override
  String get verb => '.. controls $control ..';
}

class CubicTo extends ToVerb {
  CubicTo(this.control1, this.control2, super.end);
  XY control1;
  XY control2;

  @override
  String get verb => '.. controls $control1 and $control2 ..';
}

class Arc extends PathVerb {
  Arc({
    required double r,
    String unit = '',
    required this.startAngle,
    required this.endAngle,
  }) : radius = XY.xx(r, unit: unit);
  Arc.ellipse({
    required this.radius,
    required this.startAngle,
    required this.endAngle,
  });

  final XY radius;
  final double startAngle; // In degrees.
  final double endAngle;

  @override
  String get verb => 'arc';

  @override
  List<StyleOption> get specialOptions => [
        StringOption('x radius=${radius.xu}'),
        StringOption('y radius=${radius.yu}'),
        StringOption('start angle=$startAngle'),
        StringOption('end angle=$endAngle'),
      ];
}

class GridTo extends ToVerb {
  GridTo(super.end, {double step = 1}) : step = XY.xx(step);
  GridTo.uneven(super.end, {required this.step});

  final XY step;

  @override
  String get verb => 'grid';

  @override
  List<StyleOption> get specialOptions => [StringOption('step={$step}')];
}

class Circle extends PathVerb {
  Circle(double r, {String unit = ''}) : radius = XY.xx(r, unit: unit);
  Circle.ellipse(this.radius);
  final XY radius;

  @override
  List<StyleOption> get specialOptions => [
        StringOption('x radius=${radius.xu}'),
        StringOption('y radius=${radius.yu}'),
      ];

  @override
  String get verb => 'circle';
}

class Path extends RawElement {
  Path(XY start) : _verbs = [MoveTo(start)];
  final List<PathVerb> _verbs;

  Path operator -(PathVerb verb) {
    _verbs.add(verb);
    return this;
  }

  set node(Node node) => _verbs.last.endNode = node;
  set coordinate(Coordinate coordinate) => _verbs.last.coordinate = coordinate;

  @override
  String toRaw() => _verbs.join(' ');
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

class Coordinate extends Position {
  Coordinate(this.name);
  final String name;

  @override
  String toRaw() => 'coordinate($name)';

  @override
  String get reference => name;
}
