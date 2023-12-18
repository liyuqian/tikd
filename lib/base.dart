import 'package:vector_math/vector_math_64.dart';

Vector2 xy(double x, double y) => Vector2(x, y);

List<String> indent(List<String> lines) => lines.map((l) => '  $l').toList();

abstract class RawElement {
  /// Raw string representation of the element.
  String toRaw();

  @override
  String toString() => toRaw();
}
