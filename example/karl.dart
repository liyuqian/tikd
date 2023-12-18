import 'dart:io';

import 'package:path/path.dart' as p;

import 'package:tikd/picture.dart';
import 'package:tikd/wrapper.dart';

void main() {
  final picture = TikzPicture();
  picture
    ..draw(Line([-1.5, 0], [1.5, 0]))
    ..draw(Line([0, -1.5], [0, 1.5]))
    ..draw(Circle(x: 0, y: 0, r: 1, unit: 'cm'));
  final svgPath = p.join(p.dirname(Platform.script.toFilePath()), 'karl.svg');
  LatexWrapper.fromPicture(picture).toSvg(svgPath);
}
