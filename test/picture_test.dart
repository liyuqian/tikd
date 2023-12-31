import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:tikd/tikd.dart';

import '../example/karl.dart' as karl;

void main() {
  test('Circle handles empty units', () {
    final circle = XY(0, 0) >> Circle(1);
    expect(circle.definition,
        equals(' (0.0, 0.0) circle[x radius=1.0, y radius=1.0]'));
  });

  test('Circle handles pt units', () {
    final circle = XY(0, 0) >> Circle(1, unit: 'pt');
    expect(circle.definition,
        equals(' (0.0, 0.0) circle[x radius=1.0pt, y radius=1.0pt]'));
  });

  test('Karl\'s example works', () async {
    final picture = karl.buildPicture();

    final String content = picture.buildLines().join('\n');

    // Uncomment to update the expected lines.
    // print(content);

    final expectedFilename = p.join('example', 'expected_karl_picture.tex');
    expect('$content\n', equals(File(expectedFilename).readAsStringSync()));
  });
}
