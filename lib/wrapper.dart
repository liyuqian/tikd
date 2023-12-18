import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';
import 'package:tikd/picture.dart';

const String kName = 'tikd';

class LatexWrapper {
  static const String kHeader = r'''
\documentclass[crop,tikz,multi=false]{standalone}

\usepackage{tikz}
\usepackage{tikz-cd}
\usepackage{pgfplots}
\usepackage{amsmath}
\usepackage{amssymb}

\begin{document}
''';

  static const String kFooter = r'\end{document}';

  /// From a .tex file with \begin{tikzpicture} and \end{tikzpicture}.
  LatexWrapper.fromTikzFile(String path) {
    _lines = File(path).readAsLinesSync();
  }

  LatexWrapper.fromPicture(TikzPicture picture) {
    _lines = [
      TikzPicture.kBegin,
      ...picture.buildLines(),
      TikzPicture.kEnd,
    ];
  }

  Future<void> toSvg(String svgPath) async {
    final dir = Directory.systemTemp.createTempSync(kName);
    final texFile = File('${dir.path}/tmp.tex');
    texFile.writeAsStringSync([
      kHeader,
      ..._lines,
      kFooter,
    ].join('\n'));
    final shell = Shell(workingDirectory: dir.path);
    final kSvgName = 'tmp.svg';
    await shell.run('pdflatex tmp.tex');
    await shell.run('pdf2svg tmp.pdf $kSvgName');
    final tmpPath = p.join(dir.path, kSvgName);
    File(tmpPath).renameSync(svgPath);
    print('Generated $svgPath');
    dir.deleteSync(recursive: true);
  }

  List<String> _lines = [];
}
