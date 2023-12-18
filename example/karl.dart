import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:tikd/base.dart';

import 'package:tikd/picture.dart';
import 'package:tikd/wrapper.dart';

void main() {
  final picture = TikzPicture();
  Lines([xy(-1, 0), xy(1, 0)]);
  picture
    ..draw(Lines([xy(-1.5, 0), xy(1.5, 0)]))
    ..draw(Lines([xy(0, -1.5), xy(0, 1.5)]))
    ..draw(Circle(center: xy(0, 0), radius: 1, unit: 'cm'));
  final svgPath = p.join(p.dirname(Platform.script.toFilePath()), 'karl.svg');
  LatexWrapper.fromPicture(picture).makeSvg(svgPath);
}
