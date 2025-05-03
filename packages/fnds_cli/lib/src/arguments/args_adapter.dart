part of 'arguments.dart';

/// An implementation of [ArgumentParser] that uses the 'args' package.
///
/// This is the default argument parser for the CLI framework.
class ArgsAdapter implements ArgumentParser<ArgResults> {
  final ArgParser _parser;

  /// Tracks which options are marked as mandatory
  final Set<String> _mandatoryOptions = {};

  /// Maps options to their default values for validation performance
  final Map<String, dynamic> _optionDefaults = {};

  /// Creates a new [ArgsAdapter].
  ArgsAdapter() : _parser = ArgParser();

  /// Returns a list of all mandatory option names
  Set<String> get mandatoryOptions => Set.unmodifiable(_mandatoryOptions);

  /// Returns the underlying [ArgParser] instance.
  ///
  /// This can be used to access features of the 'args' package that are not
  /// exposed by the [ArgumentParser] interface.
  ArgParser get parser => _parser;

  @override
  String get usage => _parser.usage;

  @override
  void addFlag(
    String name, {
    String? abbr,
    String? help,
    bool defaultsTo = false,
    bool negatable = true,
    bool hide = false,
  }) {
    _parser.addFlag(
      name,
      abbr: abbr,
      help: help,
      defaultsTo: defaultsTo,
      negatable: negatable,
      hide: hide,
    );

    // Store default value for later validation
    _optionDefaults[name] = defaultsTo;
  }

  @override
  void addMultiOption(
    String name, {
    String? abbr,
    String? help,
    List<String>? defaultsTo,
    bool mandatory = false,
    List<String>? allowed,
    Map<String, String>? allowedHelp,
    String? valueHelp,
    bool hide = false,
  }) {
    // Validate default values once during setup to avoid repeated validation
    if (defaultsTo != null && allowed != null) {
      for (final value in defaultsTo) {
        if (!allowed.contains(value)) {
          throw ArgumentError(
            'Default value "$value" is not in the list of allowed values for option "$name"',
          );
        }
      }
    }

    _parser.addMultiOption(
      name,
      abbr: abbr,
      help: _buildHelpText(help, mandatory),
      defaultsTo: defaultsTo,
      allowed: allowed,
      allowedHelp: allowedHelp,
      valueHelp: valueHelp,
      hide: hide,
    );

    // Track mandatory options and their defaults for faster validation
    if (mandatory) {
      _mandatoryOptions.add(name);
    }
    _optionDefaults[name] = defaultsTo;
  }

  @override
  void addOption(
    String name, {
    String? abbr,
    String? help,
    String? defaultsTo,
    bool mandatory = false,
    List<String>? allowed,
    Map<String, String>? allowedHelp,
    String? valueHelp,
    bool hide = false,
  }) {
    // Validate default values once during setup
    if (defaultsTo != null && allowed != null) {
      if (!allowed.contains(defaultsTo)) {
        throw ArgumentError(
          'Default value "$defaultsTo" is not in the list of allowed values for option "$name"',
        );
      }
    }

    _parser.addOption(
      name,
      abbr: abbr,
      help: _buildHelpText(help, mandatory),
      defaultsTo: defaultsTo,
      allowed: allowed,
      allowedHelp: allowedHelp,
      valueHelp: valueHelp,
      hide: hide,
    );

    // Track mandatory options and defaults
    if (mandatory) {
      _mandatoryOptions.add(name);
    }
    _optionDefaults[name] = defaultsTo;
  }

  /// Returns whether an option is mandatory.
  bool isMandatory(String name) => _mandatoryOptions.contains(name);

  @override
  ArgResults parse(List<String> args) {
    final results = _parser.parse(args);

    // Only validate if there are mandatory options to check
    if (_mandatoryOptions.isNotEmpty) {
      _validateMandatoryOptions(results);
    }

    return results;
  }

  /// Enhances help text for mandatory options
  String _buildHelpText(String? originalHelp, bool mandatory) {
    if (!mandatory) return originalHelp ?? '';

    final baseHelp = originalHelp ?? '';
    return '$baseHelp (Required)';
  }

  /// Validates that all mandatory options have been provided
  ///
  /// Throws an [UsageError] if any mandatory options are missing
  void _validateMandatoryOptions(ArgResults results) {
    // Early optimization - exit if there's nothing to check
    if (_mandatoryOptions.isEmpty) return;

    String? firstMissingOption;
    List<String>? missingOptions;

    for (final option in _mandatoryOptions) {
      // Fast path: Skip validation if the option was explicitly provided
      if (results.wasParsed(option)) continue;

      // An option is missing if it wasn't parsed and has no default value
      if (results[option] == null) {
        if (firstMissingOption == null) {
          // Store first missing option without creating a list
          firstMissingOption = option;
        } else {
          // Only create the list if we have more than one missing option
          missingOptions ??= [firstMissingOption];
          missingOptions.add(option);
        }
      }
    }

    if (firstMissingOption != null) {
      final optionText =
          (missingOptions?.length ?? 0) > 0 ? 'options' : 'option';
      final missingList =
          missingOptions != null
              ? missingOptions.join(', ')
              : firstMissingOption;

      throw UsageError('Missing required $optionText: $missingList');
    }
  }
}
