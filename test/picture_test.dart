import 'package:test/test.dart';
import 'package:tikd/picture.dart';

void main() {
  test('Circle handles empty units', () {
    expect(Circle(x: 0, y: 0, r: 1).toRaw(),
        equals('(0.0, 0.0) circle [radius=1.0]'));
  });

  test('Circle handles pt units', () {
    expect(Circle(x: 0, y: 0, r: 1, unit: 'pt').toRaw(),
        equals('(0.0pt, 0.0pt) circle [radius=1.0pt]'));
  });
}
