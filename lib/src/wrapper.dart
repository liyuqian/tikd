import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';

import 'base.dart';
import 'picture.dart';

const String kName = 'tikd';

const String kDartSuffix = '.dart';
const String kTexSuffix = '.tex';
const String kSvgSuffix = '.svg';

String replaceSuffix(path, String fromSuffix, String toSuffix) {
  if (!path.endsWith(fromSuffix)) {
    throw ArgumentError('Path $path does not end with $fromSuffix');
  }
  return path.substring(0, path.length - fromSuffix.length) + toSuffix;
}

class LatexWrapper {
  static const String kHeader = r'''
\documentclass[crop,tikz,multi=false]{standalone}

\usepackage{tikz}
\usepackage{tikz-cd}
\usepackage{pgfplots}
\usepackage{amsmath}
\usepackage{amssymb}

\usetikzlibrary{angles, intersections, backgrounds}

\begin{document}
''';

  static const String kFooter = r'\end{document}';

  /// From a .tex file with \begin{tikzpicture} and \end{tikzpicture}.
  LatexWrapper.fromTikzFile(String path) {
    _lines = File(path).readAsLinesSync();
  }

  LatexWrapper.fromPicture(Picture picture) {
    _lines = [
      picture.begin,
      ...indent(picture.buildLines()),
      picture.end,
    ];
  }

  Future<void> makeSvg(String svgPath) async {
    final dir = Directory.systemTemp.createTempSync(kName);
    final texFile = File('${dir.path}/tmp.tex');
    texFile.writeAsStringSync([
      kHeader,
      ..._lines,
      kFooter,
    ].join('\n'));
    final shell = Shell(workingDirectory: dir.path);
    print('Working in: ${dir.path}');
    final kSvgName = 'tmp.svg';
    final kTexName = 'tmp.tex';
    final tmpTex = p.join(dir.path, kTexName);
    final texPath = replaceSuffix(svgPath, kSvgSuffix, kTexSuffix);
    File(tmpTex).copySync(texPath);
    await shell.run('pdflatex -interaction=nonstopmode $kTexName');
    await shell.run('pdf2svg tmp.pdf $kSvgName');
    final tmpSvg = p.join(dir.path, kSvgName);
    File(tmpSvg).renameSync(svgPath);
    print('Generated $svgPath (using $texPath)');
    dir.deleteSync(recursive: true);
  }

  Future<void> makeSvgFromDart(String dartPath) async {
    await makeSvg(replaceSuffix(dartPath, kDartSuffix, kSvgSuffix));
  }

  List<String> _lines = [];
}
