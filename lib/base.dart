abstract class RawElement {
  /// Raw string representation of the element.
  String toRaw();

  @override
  String toString() => toRaw();
}
