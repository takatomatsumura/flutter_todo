import 'dart:io';

void main() {
  if (!File('scripts/install_hooks.dart').existsSync()) {
    stderr.writeln('This scripts should be executed at project root.');
    exit(1);
  }

  for (final hook in Directory('scripts/hooks').listSync()) {
    final name = hook.uri.pathSegments.last;
    final link = Link('.git/hooks/$name');
    final target = '../../${hook.path}';
    if (link.existsSync()) {
      link.updateSync(target);
    } else {
      link.createSync(target);
    }
  }
  stderr.writeln('Installed hooks successfully.');
}
