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
    final picture = TikzPicture(options: [Scale(3), LineCap.round()]);

    final axesStyle = CustomStyle(picture, 'axes', []);
    final importantLineStyle = CustomStyle(
      picture,
      'important line',
      [Thickness.veryThick()],
    );
    final informationTextStyle = CustomStyle(
      picture,
      'information text',
      [Corners.round(), Fill(Color.red % 10), InnerSep(1, unit: 'ex')],
    );

    final darkGreen = Color.green % 50 + Color.black;
    final darkOrange = Color.orange % 80 + Color.black;
    final angleColor = CustomColor(picture, 'anglecolor', darkGreen);
    final sinColor = CustomColor(picture, 'sincolor', Color.red);
    final tanColor = CustomColor(picture, 'tancolor', darkOrange);
    final cosColor = CustomColor(picture, 'coscolor', Color.blue);

    // Uncomment to update the expected lines.
    // print(picture.lines.join('\n'));

    expect(picture.buildLines().join('\n'), equals(r'''
[
  scale=3.0,
  line cap=round,
  axes/.style={},
  important line/.style={very thick},
  information text/.style={rounded corners, fill=red!10, inner sep=1.0ex},
]
\colorlet{anglecolor}{green!50!black}
\colorlet{sincolor}{red}
\colorlet{tancolor}{orange!80!black}
\colorlet{coscolor}{blue}'''));
  });
}
