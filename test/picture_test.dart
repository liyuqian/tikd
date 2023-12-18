import 'package:test/test.dart';
import 'package:tikd/picture.dart';
import 'package:tikd/style.dart';

void main() {
  test('Circle handles empty units', () {
    expect(Circle(x: 0, y: 0, r: 1).toRaw(),
        equals('(0.0, 0.0) circle [radius=1.0]'));
  });

  test('Circle handles pt units', () {
    expect(Circle(x: 0, y: 0, r: 1, unit: 'pt').toRaw(),
        equals('(0.0pt, 0.0pt) circle [radius=1.0pt]'));
  });

  test('Karl\'s example works', () {
    final picture = TikzPicture(
      options: [Scale(3), LineCap.round()],
      namedStyles: [
        Style('axes', []),
        Style('important line', [Thickness.veryThick()]),
        Style('information text', [
          Corners.round(),
          Fill(ColorName.red().percent(10)),
          InnerSep(1, unit: 'ex'),
        ]),
      ],
    );
    expect(picture.lines.join('\n'), equals(r'''
[
  scale=3.0,
  line cap=round,
  axes/.style={},
  important line/.style={very thick},
  information text/.style={rounded corners, fill=red!10, inner sep=1.0ex},
]'''));
  });
}
