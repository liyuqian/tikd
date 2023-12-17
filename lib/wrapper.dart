import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';

const String kName = 'tikd';

class TikzWrapper {
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

  TikzWrapper.fromFile(String path) {
    _lines = File(path).readAsLinesSync();
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
    dir.deleteSync(recursive: true);
  }

  List<String> _lines = [];
}
