String str(Object? o) => o == null ? '' : o.toString();
List<String> lstr(Object? o) => o == null ? [] : [o.toString()];

List<String> indent(List<String> lines) => lines.map((l) => '  $l').toList();

abstract class RawElement {
  /// Raw string representation of the element.
  String toRaw();

  @override
  String toString() => reference;

  // Can be overriden
  String get reference => toRaw();
  String get definition => toRaw();

  String get ref => reference;
  String get def => definition;

  List<String> toLines() => [definition];
}

class RawString extends RawElement {
  RawString(this.raw);
  final String raw;

  @override
  String toRaw() => raw;
}
