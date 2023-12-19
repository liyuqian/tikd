import 'package:vector_math/vector_math_64.dart';

Vector2 xy(double x, double y) => Vector2(x, y);
String str(Object? o) => o == null ? '' : o.toString();

List<String> indent(List<String> lines) => lines.map((l) => '  $l').toList();

abstract class RawElement {
  /// Raw string representation of the element.
  String toRaw();

  @override
  String toString() => toRaw();

  List<String> toLines() => [toRaw()];
}

class RawString extends RawElement {
  RawString(this.raw);
  final String raw;

  @override
  String toRaw() => raw;
}
