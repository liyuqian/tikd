import 'dart:io';

import 'package:args/args.dart';
import 'package:process_run/shell.dart';
import 'package:tikd/tikd.dart';

const String version = '0.0.1';

const String kStrHelp = 'help';
const String kStrVersion = 'version';
const String kStrWatch = 'watch';

const String kStrPositionalName = 'tikz tex or dart file path';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      kStrHelp,
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      kStrVersion,
      negatable: false,
      help: 'Print the tool version.',
    )
    ..addFlag(
      kStrWatch,
      abbr: 'w',
      negatable: false,
      help: 'Watch the file change.',
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: dart tikd.dart <flags> [$kStrPositionalName]');
  print(argParser.usage);
}

Future<void> tikzToSvg(String texPath) async {
  final String svgPath = replaceSuffix(texPath, kTexSuffix, kSvgSuffix);
  await LatexWrapper.fromTikzFile(texPath).makeSvg(svgPath);
}

Future<void> dartToSvg(String dartPath) async {
  await Shell().run('dart $dartPath');
}

Future<void> main(List<String> arguments) async {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);

    if (results.wasParsed(kStrHelp)) {
      printUsage(argParser);
      return;
    }
    if (results.wasParsed(kStrVersion)) {
      print('tikd version: $version');
      return;
    }
    if (results.rest.length != 1) {
      print('There must be 1 positional argument [$kStrPositionalName].');
      printUsage(argParser);
      exit(1);
    }

    final bool isWatching = results.wasParsed(kStrWatch);
    final String filepath = results.rest[0];

    final bool isDart = filepath.endsWith(kDartSuffix);
    final bool isTex = filepath.endsWith(kTexSuffix);

    if (!isTex && !isDart) {
      print('Error: $filepath does not have a valid suffix.');
      printUsage(argParser);
      exit(1);
    }

    Future<void> build() async {
      try {
        await (isDart ? dartToSvg(filepath) : tikzToSvg(filepath));
      } catch (e) {
        print('Error: $filepath failed to build: $e');
      }
    }

    await build();

    if (isWatching) {
      File(filepath)
          .watch(events: FileSystemEvent.modify)
          .listen((event) async {
        print('File change: $event');
        await build();
      });
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
