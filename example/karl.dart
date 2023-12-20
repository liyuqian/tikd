import 'dart:io';

import 'package:path/path.dart' as p;

import 'package:tikd/picture.dart';
import 'package:tikd/wrapper.dart';

void main() {
  final picture = TikzPicture();
  final svgPath = p.join(p.dirname(Platform.script.toFilePath()), 'karl.svg');
  LatexWrapper.fromPicture(picture).makeSvg(svgPath);
}
