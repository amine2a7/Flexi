// Régénère packages/fp_api depuis le contrat OpenAPI.
// Usage (depuis apps/mobile) : melos run generate:api
// Prérequis : Node (npx) et un JDK 17+ dans le PATH ou JAVA_HOME.
import 'dart:io';

Future<void> main() async {
  final toolDir = File.fromUri(Platform.script).parent;
  final apiDir = Directory('${toolDir.parent.path}/packages/fp_api');

  await _run('npx', [
    '--yes',
    '@openapitools/openapi-generator-cli@2',
    'generate',
    '-c',
    'fp_api.openapi.yaml',
  ], toolDir.path);

  _patchPubspec(File('${apiDir.path}/pubspec.yaml'));
  _addMissingModelImports(Directory('${apiDir.path}/lib/src/model'));

  await _run('dart', [
    'run',
    'build_runner',
    'build',
  ], apiDir.path);
}

/// Le paquet généré doit appartenir au pub workspace.
void _patchPubspec(File pubspec) {
  var text = pubspec.readAsStringSync();
  text = text.replaceFirst(RegExp(r"sdk: '>=[^']*'"), 'sdk: ^3.13.0');
  if (!text.contains('resolution: workspace')) {
    text = text.replaceFirst(
      'environment:',
      'resolution: workspace\n\nenvironment:',
    );
  }
  pubspec.writeAsStringSync(text);
}

/// Contournement d'un bug de dart-dio (OpenAPI 3.1, `allOf` + `const`) :
/// un modèle qui hérite d'une propriété typée par un autre modèle (ex. `ProblemCode`)
/// ne reçoit pas l'import correspondant. On l'ajoute de façon déterministe.
void _addMissingModelImports(Directory modelDir) {
  final files = modelDir.listSync().whereType<File>().where(
    (f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'),
  );
  final classToFile = <String, String>{};
  for (final f in files) {
    final m = RegExp(
      r'^(?:abstract )?class (\w+)',
      multiLine: true,
    ).firstMatch(f.readAsStringSync());
    if (m != null) classToFile[m.group(1)!] = f.uri.pathSegments.last;
  }
  for (final f in files) {
    var text = f.readAsStringSync();
    final own = f.uri.pathSegments.last;
    final missing = <String>{};
    for (final m in RegExp(r'FullType\((\w+)\)').allMatches(text)) {
      final file = classToFile[m.group(1)!];
      if (file != null && file != own && !text.contains("/$file'")) {
        missing.add(file);
      }
    }
    if (missing.isEmpty) continue;
    final imports = missing
        .map((file) => "import 'package:fp_api/src/model/$file';")
        .join('\n');
    text = text.replaceFirst(
      "import 'package:built_value/built_value.dart';",
      "$imports\nimport 'package:built_value/built_value.dart';",
    );
    f.writeAsStringSync(text);
  }
}

Future<void> _run(String exe, List<String> args, String cwd) async {
  final process = await Process.start(
    exe,
    args,
    workingDirectory: cwd,
    runInShell: true,
    mode: ProcessStartMode.inheritStdio,
  );
  final code = await process.exitCode;
  if (code != 0) {
    stderr.writeln('Échec : $exe ${args.join(' ')} (code $code)');
    exit(code);
  }
}
