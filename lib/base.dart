String str(Object? o) => o == null ? '' : o.toString();
List<String> lstr(Object? o) => o == null ? [] : [o.toString()];

List<String> indent(List<String> lines) => lines.map((l) => '  $l').toList();

abstract class Referable {
  // To be overriden.
  String get definition;

  // Can be overriden.
  String get reference => definition;

  String get ref => reference;
  String get def => definition;

  List<String> toLines() => [definition];

  @override
  String toString() => reference;
}

class RawString extends Referable {
  RawString(this.raw);
  final String raw;

  @override
  String get definition => raw;
}
