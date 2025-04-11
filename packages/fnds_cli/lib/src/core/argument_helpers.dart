/// Helper functions for finding values in raw argument lists.
/// These are best-effort and don't replicate full ArgParser logic.
part of 'core.dart';

/// Checks if a flag is present in the argument list.
/// Handles `--flag` and basic aliases like `-f`.
/// Does NOT check for negating flags like --no-flag unless explicitly passed.
bool findFlag({
  required String flagName,
  required List<String> aliases,
  required List<String> args,
}) {
  final Set<String> flagMarkers = {'--$flagName', ...aliases};
  return args.any((arg) => flagMarkers.contains(arg));
}

/// Tries to find all values for a multi-option.
/// Handles repeated `--option value` or `--option=value`.
List<String> findMultiOptionValues({
  required String optionName,
  required List<String> aliases,
  required List<String> args,
}) {
  final Set<String> optionMarkers = {'--$optionName', ...aliases};
  final String optionPrefix = '--$optionName=';
  final List<String> values = [];

  for (int i = 0; i < args.length; i++) {
    final arg = args[i];

    if (optionMarkers.contains(arg)) {
      if (i + 1 < args.length && !args[i + 1].startsWith('-')) {
        values.add(args[i + 1]);
        // Don't skip i+1 here in case it's also a valid value for another arg?
        // Or assume one value per flag instance? Let's assume one for now.
        // i++; // If you assume one value per flag instance
      }
    } else if (arg.startsWith(optionPrefix)) {
      values.add(arg.substring(optionPrefix.length));
    }
  }
  return values;
}

/// Checks if a negating flag (e.g., --no-flag) is present.
bool findNegatingFlag({required String flagName, required List<String> args}) {
  final negatingFlag = '--no-$flagName';
  return args.contains(negatingFlag);
}

/// Tries to find the value for a given option in a list of arguments.
/// Handles `--option value` and `--option=value`. Basic alias support.
/// Returns null if not found. (Doesn't handle multi-options)
String? findOptionValue({
  required String optionName,
  required List<String> aliases,
  required List<String> args,
}) {
  final Set<String> optionMarkers = {'--$optionName', ...aliases};
  final String optionPrefix = '--$optionName=';

  for (int i = 0; i < args.length; i++) {
    final arg = args[i];

    if (optionMarkers.contains(arg)) {
      // Check if next arg exists and is not another option
      if (i + 1 < args.length && !args[i + 1].startsWith('-')) {
        return args[i + 1];
      }
    } else if (arg.startsWith(optionPrefix)) {
      return arg.substring(optionPrefix.length);
    }
  }
  return null;
}
