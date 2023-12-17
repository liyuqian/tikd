import 'dart:io';

import 'package:args/args.dart';
import 'package:process_run/shell.dart';
import 'package:tikd/wrapper.dart';

const String version = '0.0.1';

const String kStrHelp = 'help';
const String kStrVersion = 'version';
const String kStrWatch = 'watch';

const String kStrPositionalName = 'tikz tex file path';

const String kTexSuffix = '.tex';
const String kSvgSuffix = '.svg';

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
  final String svgPath =
      texPath.substring(0, texPath.length - kTexSuffix.length) + kSvgSuffix;
  await TikzWrapper.fromFile(texPath).toSvg(svgPath);
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
      print('dartpost version: $version');
      return;
    }
    if (results.rest.length != 1) {
      print('There must be 1 positional argument [$kStrPositionalName].');
      printUsage(argParser);
      exit(1);
    }

    final bool isWatching = results.wasParsed(kStrWatch);
    final String texPath = results.rest[0];

    if (!texPath.endsWith(kTexSuffix)) {
      print('Error: $texPath does not have a $kTexSuffix suffix.');
      printUsage(argParser);
      exit(1);
    }

    await tikzToSvg(texPath);

    if (isWatching) {
      File(texPath).watch(events: FileSystemEvent.modify).listen((event) async {
        print('File change: $event');
        await tikzToSvg(texPath);
      });
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
