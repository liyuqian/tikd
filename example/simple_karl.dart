import 'dart:io';
import 'dart:math';

import 'package:tikd/geometry.dart';
import 'package:tikd/picture.dart';
import 'package:tikd/style.dart';
import 'package:tikd/wrapper.dart';
import 'package:path/path.dart' as p;
import 'package:vector_math/vector_math_64.dart';

TikzPicture buildPicture() {
  final picture = TikzPicture(options: [Scale(3), LineCap.round()]);
  buildAxis(picture);
  buildPlot(picture);
  buildText(picture);
  return picture;
}

void main() {
  final picture = buildPicture();
  final svgPath = p.join(p.dirname(Platform.script.toFilePath()), 'karl.svg');
  LatexWrapper.fromPicture(picture).makeSvg(svgPath);
}

String $(String s) => '\$$s\$';

void buildAxis(TikzPicture picture) {
  final xAxis = XY(-1.5, 0) >>> XY(1.5, 0)
    ..endNode = Node(r'$x$', place: Placement.right());
  final yAxis = XY(0, -1.5) >>> XY(0, 1.5)
    ..endNode = Node(r'$y$', place: Placement.above());
  final kSW = XY(-1.4, -1.4), kNE = XY(1.4, 1.4);
  picture
    ..draw(kSW >> GridTo(kNE, step: 0.5), options: [helpLinesStyle])
    ..draw(xAxis, options: [singleArrowStyle])
    ..draw(yAxis, options: [singleArrowStyle]);

  String fraction(double v) =>
      v.abs() == 0.5 ? '${v < 0 ? '-' : ''}\\frac{1}{2}' : '${v.round()}';
  final fillWhite = Fill(Color.white);
  for (double v = -1; v <= 1; v += 0.5) {
    final xPlace = Placement.below(), yPlace = Placement.left();
    final xNode = Node($(fraction(v)), place: xPlace, options: [fillWhite]);
    final yNode = Node($(fraction(v)), place: yPlace, options: [fillWhite]);
    final xTick = XY(0, 1, unit: 'pt') >>> XY(0, -1, unit: 'pt');
    final yTick = XY(1, 0, unit: 'pt') >>> XY(-1, 0, unit: 'pt');
    if (v != 0 && v != 0.5) {
      picture.draw(xTick..endNode = xNode, options: [Shift(XY.x(v))]);
    }
    if (v != 0) {
      picture.draw(yTick..endNode = yNode, options: [Shift(XY.y(v))]);
    }
  }
}

void buildPlot(TikzPicture picture) {
  final sinColor = CustomColor(picture, 'sincolor', Color.red);
  final angleColor =
      CustomColor(picture, 'anglecolor', Color.green % 50 + Color.black);
  final String sinAlpha = r'\sin \alpha';
  final String cosAlpha = r'\cos \alpha';
  final String tanAlpha = r'\tan \alpha';
  final sinLine = XY.polar(30, 1) >>> XY(cos(radians(30)), 0)
    ..midNode = Node($(sinAlpha), place: Placement.left());
  final cosLine = XY(0, 0) >>> XY(cos(radians(30)), 0)
    ..midNode = Node($(cosAlpha), place: Placement.below());
  final sinOverCos = '\\color{black} = '
      '\\frac{\\color{red} $sinAlpha}{\\color{blue} $cosAlpha}';
  final tanLine = XY(1, tan(radians(30))) >>> XY(1, 0)
    ..midNode = Node($('\\displaystyle $tanAlpha $sinOverCos'),
        place: Placement.right());
  final angle = XY(0, 0) >>> XY(0.3, 0) >> Arc(start: 0, end: 30, r: 0.3);
  picture
    ..draw(XY(0, 0) >> Circle(1))
    ..draw(XY(0, 0) >>> XY(1, tan(radians(30))))
    ..draw(sinLine, options: [Thickness.veryThick(), sinColor])
    ..draw(cosLine, options: [Thickness.veryThick(), Color.blue])
    ..draw(tanLine, options: [Thickness.veryThick(), Color.orange])
    ..filldraw(angle, options: [Fill(Color.green % 20), Draw(angleColor)])
    ..draw(Path(XY.polar(15, 2, unit: 'mm'))
      ..endNode = Node(r'$\alpha$', options: [angleColor]));
}

void buildText(TikzPicture picture) {
  final informationTextStyle = CustomStyle(picture, 'information text',
      [Corners.rounded(), Fill(Color.red % 10), InnerSep(1, unit: 'ex')]);
  final textLines = [
    '',
    r'The {\color{anglecolor} angle $\alpha$} is $30^\circ$ in the',
    r'example ($\pi/6$ in radians). The {\color{sincolor}sine of',
    r'$\alpha$}, which is the height of the red line, is',
    r'\[',
    r'{\color{sincolor} \sin \alpha} = 1/2.',
    r'\]',
    r'By the Theorem of Pythagoras ...',
  ];
  final textNode = Node(textLines.join('\n'),
      place: Placement.right(),
      options: [TextWidth(6, unit: 'cm'), informationTextStyle]);
  picture.draw(textNode, options: [Shift(XY.x(1.85, unit: 'cm'))]);
}
