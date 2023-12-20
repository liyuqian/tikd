import 'dart:io';

import 'package:test/test.dart';
import 'package:tikd/geometry.dart';
import 'package:tikd/picture.dart';
import 'package:tikd/style.dart';
import 'package:path/path.dart' as p;

void main() {
  test('Circle handles empty units', () {
    final circle = XY(0, 0) - Circle(1);
    expect(circle.toRaw(),
        equals(' (0.0, 0.0) circle[x radius=1.0, y radius=1.0]'));
  });

  test('Circle handles pt units', () {
    final circle = XY(0, 0) - Circle(1, unit: 'pt');
    expect(circle.toRaw(),
        equals(' (0.0, 0.0) circle[x radius=1.0pt, y radius=1.0pt]'));
  });

  test('Karl\'s example works', () async {
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

    final grid = XY(-1.4, -1.4) - GridTo(XY(1.4, 1.4), step: 0.5);
    picture.draw(grid, options: [helpLinesStyle]);

    picture.draw(XY(0, 0) - Circle(1));

    final xAxis = XY(-1.5, 0) - LineTo(XY(1.5, 0))
      ..node = Node(place: Placement.right, content: r'$x$')
      ..coordinate = Coordinate('x axis');
    final yAxis = XY(0, -1.5) - LineTo(XY(0, 1.5))
      ..node = Node(place: Placement.above, content: r'$y$')
      ..coordinate = Coordinate('y axis');
    final axesScope = Scope(options: [axesStyle])
      ..draw(xAxis, options: [singleArrowStyle])
      ..draw(yAxis, options: [singleArrowStyle]);
    picture.addScope(axesScope);
    for (final x in <double>[-1, -.5, 1]) {
      final tick = XY(0, 1, unit: 'pt') - LineTo(XY(0, -1, unit: 'pt'))
        ..node = Node(
            place: Placement.below,
            options: [Fill(Color.white)],
            content: '\$$x\$');
      axesScope.draw(tick, options: [Shift(XY(x, 0, unit: 'cm'))]);
    }
    for (final y in <double>[-1, -.5, .5, 1]) {
      final tick = XY(1, 0, unit: 'pt') - LineTo(XY(-1, 0, unit: 'pt'))
        ..node = Node(
            place: Placement.left,
            options: [Fill(Color.white)],
            content: '\$$y\$');
      axesScope.draw(tick, options: [Shift(XY(0, y, unit: 'cm'))]);
    }

    final arc = Arc(r: 3, unit: 'mm', startAngle: 0, endAngle: 30);
    picture.filldraw(XY(0, 0) - LineTo(XY(3, 0, unit: 'mm')) - arc,
        options: [Fill(Color.green % 20), Draw(angleColor)]);

    // Uncomment to generate the SVG.
    // await LatexWrapper.fromPicture(picture).makeSvg('/tmp/picture_test.svg');

    final String content = picture.buildLines().join('\n');

    // Uncomment to update the expected lines.
    // print(content);

    final expectedFilename = p.join('test', 'expected_karl_picture.tex');
    expect('$content\n', equals(File(expectedFilename).readAsStringSync()));
  });
}
