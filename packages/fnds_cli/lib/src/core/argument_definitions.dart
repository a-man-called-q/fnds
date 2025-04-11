part of 'core.dart';

/// Base class for declaratively defining command arguments.
abstract class ArgumentDefinition<T> {
  final String name;
  final String help;
  final String? abbr;
  final T? defaultsTo;
  final bool isRequired;
  final String? interactivePromptLabel; // Optional custom label for prompt
  final String?
  interactivePromptQuestion; // Optional custom question for prompt

  ArgumentDefinition({
    required this.name,
    required this.help,
    this.abbr,
    this.defaultsTo,
    this.interactivePromptLabel,
    this.interactivePromptQuestion,
  }) : isRequired = defaultsTo == null;

  List<String> get _aliases => abbr == null ? [] : [abbr!];

  /// Formats the final value back into command line arguments.
  void addValueToArgList(List<String> argList, T value);

  /// Configures the standard ArgParser based on this definition.
  void configureArgParser(ArgParser parser);

  /// Tries to find the original value provided in the raw argument list.
  dynamic findOriginalValue(List<String> originalArgs);

  /// Calls the appropriate interactive function via the prompter.
  Future<T> promptInteractively(
    dynamic originalValue, // Value found by findOriginalValue
    InteractivePrompter prompter,
  );
}

class FlagArgument extends ArgumentDefinition<bool> {
  final bool negatable;

  FlagArgument({
    required super.name,
    required super.help,
    super.abbr,
    super.defaultsTo = false,
    super.interactivePromptLabel,
    super.interactivePromptQuestion,
    this.negatable = false,
  });

  @override
  void addValueToArgList(List<String> argList, bool value) {
    // Add flag if value differs from default, considering negatable
    if (value && !(defaultsTo ?? false)) {
      argList.add('--$name');
    } else if (!value && (defaultsTo ?? false) && negatable) {
      argList.add('--no-$name');
    }
  }

  @override
  void configureArgParser(ArgParser parser) {
    parser.addFlag(
      name,
      abbr: abbr,
      help: help,
      defaultsTo: defaultsTo,
      negatable: negatable,
    );
  }

  @override
  dynamic findOriginalValue(List<String> originalArgs) {
    if (negatable && findNegatingFlag(flagName: name, args: originalArgs)) {
      return false;
    }
    return findFlag(flagName: name, aliases: _aliases, args: originalArgs)
        ? true
        : false;
  }

  @override
  Future<bool> promptInteractively(
    dynamic originalValue,
    InteractivePrompter prompter,
  ) async {
    return await prompter.confirm(
      promptLabel: interactivePromptLabel ?? name,
      promptQuestion: interactivePromptQuestion ?? 'Enable "$name"?',
      defaultValue: defaultsTo ?? false,
      originalValue: originalValue as bool?,
    );
  }
}

class MultiSelectArgument<T> extends ArgumentDefinition<List<T>> {
  final List<T> allowedValues;
  final List<String>? optionLabels;

  MultiSelectArgument({
    required super.name,
    required super.help,
    required this.allowedValues,
    this.optionLabels,
    super.abbr,
    List<T>? defaultsTo, // Default is now a List
    super.interactivePromptLabel,
    super.interactivePromptQuestion,
  }) : assert(allowedValues.isNotEmpty),
       assert(
         optionLabels == null || optionLabels.length == allowedValues.length,
       ),
       super(
         defaultsTo: defaultsTo ?? const [],
       ); // Ensure default is non-null list

  @override
  void addValueToArgList(List<String> argList, List<T> value) {
    // Add each selected value as a separate instance of the option
    for (final item in value) {
      argList.addAll(['--$name', _displayValue(item)]);
    }
  }

  @override
  void configureArgParser(ArgParser parser) {
    final allowedStrings = allowedValues.map(_displayValue).toList();
    parser.addMultiOption(
      name,
      abbr: abbr,
      help: "$help\n(Allowed: ${allowedStrings.join(', ')})",
      defaultsTo: defaultsTo?.map(_displayValue).toList() ?? [],
      allowed: allowedStrings,
    );
  }

  @override
  dynamic findOriginalValue(List<String> originalArgs) {
    List<String> stringValues = findMultiOptionValues(
      optionName: name,
      aliases: _aliases,
      args: originalArgs,
    );
    if (stringValues.isNotEmpty) {
      return stringValues
          .map(
            (sv) => allowedValues.firstWhere(
              (v) => _displayValue(v) == sv,
              orElse:
                  () =>
                      throw CliException(
                        'Invalid value "$sv" provided for multi-select option "$name".',
                      ),
            ),
          )
          .whereType<T>()
          .toList(); // Filter out nulls and ensure type
    }
    return <T>[]; // Return empty list if none found
  }

  @override
  Future<List<T>> promptInteractively(
    dynamic originalValue,
    InteractivePrompter prompter,
  ) async {
    return await prompter.multiSelect<T>(
      promptLabel: interactivePromptLabel ?? name,
      promptQuestion:
          interactivePromptQuestion ?? 'Select value(s) for "$name"',
      options: allowedValues,
      optionLabels: optionLabels,
      defaultValues: defaultsTo, // Pass List<T> default
      originalValues: originalValue as List<T>?,
    );
  }

  String _displayValue(T value) {
    int index = allowedValues.indexOf(value);
    if (optionLabels != null && index != -1) return optionLabels![index];
    return value.toString();
  }
}

class SelectArgument<T> extends ArgumentDefinition<T> {
  final List<T> allowedValues;
  final List<String>? optionLabels; // Corresponds to user's optionLabels
  // Note: display function from previous example is removed as user's select uses optionLabels

  SelectArgument({
    required super.name,
    required super.help,
    required this.allowedValues,
    this.optionLabels,
    super.abbr,
    super.defaultsTo,
    super.interactivePromptLabel,
    super.interactivePromptQuestion,
  }) : assert(
         allowedValues.isNotEmpty,
         'SelectArgument requires allowed values.',
       ),
       assert(
         optionLabels == null || optionLabels.length == allowedValues.length,
         'optionLabels must match allowedValues length.',
       );

  @override
  void addValueToArgList(List<String> argList, T value) {
    // Add the string representation that ArgParser expects
    argList.addAll(['--$name', _displayValue(value)]);
  }

  @override
  void configureArgParser(ArgParser parser) {
    final allowedStrings = allowedValues.map(_displayValue).toList();
    parser.addOption(
      name,
      abbr: abbr,
      help: "$help\n(Allowed: ${allowedStrings.join(', ')})",
      defaultsTo: defaultsTo != null ? _displayValue(defaultsTo as T) : null,
      allowed: allowedStrings,
    );
  }

  @override
  dynamic findOriginalValue(List<String> originalArgs) {
    String? stringValue = findOptionValue(
      optionName: name,
      aliases: _aliases,
      args: originalArgs,
    );
    if (stringValue == null) return null;
    return allowedValues.firstWhere(
      (v) => _displayValue(v) == stringValue,
      orElse:
          () =>
              throw CliException(
                'Invalid value "$stringValue" provided for select option "$name".',
              ),
    );
  }

  @override
  Future<T> promptInteractively(
    dynamic originalValue,
    InteractivePrompter prompter,
  ) async {
    return await prompter.select<T>(
      promptLabel: interactivePromptLabel ?? name,
      promptQuestion: interactivePromptQuestion ?? 'Select value for "$name"',
      options: allowedValues,
      optionLabels: optionLabels,
      defaultValue: defaultsTo, // Pass T default
      originalValue: originalValue as T?,
    );
  }

  // Helper to get string representation for ArgParser and finding original
  String _displayValue(T value) {
    int index = allowedValues.indexOf(value);
    if (optionLabels != null && index != -1) {
      return optionLabels![index];
    }
    return value.toString();
  }
}

// --- Concrete Implementations ---

class StringArgument extends ArgumentDefinition<String> {
  final bool isSecretive;
  StringArgument({
    required super.name,
    required super.help,
    super.abbr,
    super.defaultsTo,
    super.interactivePromptLabel,
    super.interactivePromptQuestion,
    this.isSecretive = false,
  });

  @override
  void addValueToArgList(List<String> argList, String value) {
    argList.addAll(['--$name', value]);
  }

  @override
  void configureArgParser(ArgParser parser) {
    parser.addOption(name, abbr: abbr, help: help, defaultsTo: defaultsTo);
  }

  @override
  dynamic findOriginalValue(List<String> originalArgs) {
    return findOptionValue(
      optionName: name,
      aliases: _aliases,
      args: originalArgs,
    );
  }

  @override
  Future<String> promptInteractively(
    dynamic originalValue,
    InteractivePrompter prompter,
  ) async {
    return await prompter.askString(
      promptLabel: interactivePromptLabel ?? name, // Use name as default label
      promptQuestion: interactivePromptQuestion ?? 'Enter value for "$name"',
      defaultValue: defaultsTo,
      originalValue: originalValue as String?,
      isSecretive: isSecretive, // Use isSecretive here
    );
  }
}

// Add IntArgument etc.
