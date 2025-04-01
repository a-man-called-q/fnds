part of 'utils.dart';

Future<String> getName() async {
  String? fullName;

  if (Platform.isWindows) {
    fullName = await _getWindowsProfileName();
  } else if (Platform.isLinux || Platform.isMacOS) {
    fullName = await _getUnixProfileName();
  }

  return _formatName(fullName);
}

String _formatName(String? fullName) {
  if (fullName == null || fullName.trim().isEmpty) return '';

  var words = fullName.split(RegExp(r'\s+')); // Split by any whitespace
  return words.length > 2 ? '${words[0]} ${words[1]}' : fullName;
}

Future<String?> _getUnixProfileName() async {
  String? output = await _runCommand([
    'getent',
    'passwd',
    Platform.environment['USER'] ?? '',
  ]);
  return output?.split(':').elementAtOrNull(4);
}

Future<String?> _getWindowsProfileName() async {
  String? output = await _runCommand([
    'wmic',
    'useraccount',
    'where',
    'name="%USERNAME%"',
    'get',
    'fullname',
  ]);
  return output?.split('\n').elementAtOrNull(1)?.trim();
}

Future<String?> _runCommand(List<String> command) async {
  try {
    var result = await Process.run(
      command.first,
      command.sublist(1),
      runInShell: true,
    );
    return result.stdout.toString().trim().isNotEmpty
        ? result.stdout.toString().trim()
        : null;
  } catch (e) {
    return null;
  }
}

extension ListSafeAccess<T> on List<T> {
  T? elementAtOrNull(int index) =>
      (index >= 0 && index < length) ? this[index] : null;
}
