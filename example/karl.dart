import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:tikd/path.dart';

import 'package:tikd/picture.dart';
import 'package:tikd/style.dart';
import 'package:tikd/wrapper.dart';

Picture buildPicture() {
  final picture = Picture(options: [Scale(3), LineCap.round()]);

  final axesStyle = CustomStyle(picture, 'axes', []);
  final importantLineStyle = CustomStyle(
    picture,
    'important line',
    [Thickness.veryThick()],
  );
  final informationTextStyle = CustomStyle(
    picture,
    'information text',
    [Corners.rounded(), Fill(Color.red % 10), InnerSep(1, unit: 'ex')],
  );

  final darkGreen = Color.green % 50 + Color.black;
  final angleColor = CustomColor(picture, 'anglecolor', darkGreen);
  final sinColor = CustomColor(picture, 'sincolor', Color.red);
  final cosColor = CustomColor(picture, 'coscolor', Color.blue);

  final grid = XY(-1.4, -1.4) >> GridTo(XY(1.4, 1.4), step: 0.5);
  picture.draw(grid, options: [helpLinesStyle]);

  picture.draw(XY(0, 0) >> Circle(1));

  String fraction(double v) =>
      v.abs() == 0.5 ? '${v < 0 ? '-' : ''}\\frac{1}{2}' : '${v.round()}';

  final xAxisCoordinate = Coordinate('x axis');
  final yAxisCoordinate = Coordinate('y axis');
  final xAxis = XY(-1.5, 0) >>> XY(1.5, 0)
    ..endNode = Node(r'$x$', place: Placement.right())
    ..coordinate = xAxisCoordinate;
  final yAxis = XY(0, -1.5) >>> XY(0, 1.5)
    ..endNode = Node(r'$y$', place: Placement.above())
    ..coordinate = yAxisCoordinate;
  final axesScope = Scope(options: [axesStyle])
    ..draw(xAxis, options: [singleArrowStyle])
    ..draw(yAxis, options: [singleArrowStyle]);
  picture.addScope(axesScope);
  for (final x in <double>[-1, -.5, 1]) {
    final tick = XY(0, 1, unit: 'pt') >>> XY(0, -1, unit: 'pt')
      ..endNode = Node('\$${fraction(x)}\$',
          place: Placement.below(), options: [Fill(Color.white)]);
    axesScope.draw(tick, options: [Shift(XY(x, 0, unit: 'cm'))]);
  }
  for (final y in <double>[-1, -.5, .5, 1]) {
    final tick = XY(1, 0, unit: 'pt') >>> XY(-1, 0, unit: 'pt')
      ..endNode = Node('\$${fraction(y)}\$',
          place: Placement.left(), options: [Fill(Color.white)]);
    axesScope.draw(tick, options: [Shift(XY(0, y, unit: 'cm'))]);
  }

  final arc = Arc(r: 3, unit: 'mm', start: 0, end: 30);
  picture.filldraw(XY(0, 0) >>> XY(3, 0, unit: 'mm') >> arc,
      options: [Fill(Color.green % 20), Draw(angleColor)]);

  picture.draw(Path(XY.polar(15, 2, unit: 'mm'))
    ..endNode = Node(r'$\alpha$', options: [angleColor]));

  picture.draw(
      XY.polar(30, 1) >>> (XY.polar(30, 1) >= xAxisCoordinate)
        ..midNode = Node(r'$\sin \alpha$',
            place: Placement.left(by: 1, unit: 'pt'),
            options: [Fill(Color.white)]),
      options: [importantLineStyle, sinColor]);

  picture.draw(
      (XY.polar(30, 1) >= xAxisCoordinate) >>> XY(0, 0)
        ..midNode = Node(r'$\cos \alpha$',
            place: Placement.below(by: 1, unit: 'pt'),
            options: [Fill(Color.white)]),
      options: [importantLineStyle, cosColor]);

  const String kUpwardLine = 'upward line';
  const String kSlopedLine = 'sloped line';
  picture.namePath(XY(1, 0) >>> XY(1, 1), kUpwardLine);
  picture.namePath(XY(0, 0) >>> XY.polar(30, 1.5), kSlopedLine);
  final intersection = Intersection(kUpwardLine, kSlopedLine, 't');
  picture.draw(
      XY(1, 0) >>> intersection.position
        ..midNode = Node(
            r'$\displaystyle \tan \alpha \color{black}='
            r'\frac{{\color{red}\sin \alpha}}{\color{blue}\cos \alpha}$',
            place: Placement.right(by: 1, unit: 'pt'),
            options: [Fill(Color.white)]),
      options: [intersection, Thickness.veryThick(), Color.orange]);

  picture.draw(XY(0, 0) >>> intersection.position);

  picture.draw(
      Node(
          r'The {\color{anglecolor} angle $\alpha$} is $30^\circ$ in the '
          r'example ($\pi/6$ in radians). The {\color{sincolor}sine of '
          r'$\alpha$}, which is the height of the red line, is'
          r'\['
          r'\sin \alpha = 1/2.'
          r'\]'
          r'By the Theorem of Pythagoras ...',
          place: Placement.right(),
          options: [TextWidth(6, unit: 'cm'), informationTextStyle]),
      options: [Shift(XY(1.85, 0))]);

  return picture;
}

void main() {
  final picture = buildPicture();
  final svgPath = p.join(p.dirname(Platform.script.toFilePath()), 'karl.svg');
  LatexWrapper.fromPicture(picture).makeSvg(svgPath);
}
