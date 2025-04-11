part of 'core.dart';

/// Abstract base class for all commands and subcommands.
abstract class CliCommand {
  /// The prompter instance used for interactive fallback.
  /// Provided via constructor from CliApp.
  final InteractivePrompter prompter;

  // Lazily build the parser from definitions
  late final ArgParser _argParser = _buildParser();

  CliCommand(this.prompter);
  List<String> get aliases => [];
  ArgParser get argParser => _argParser;

  /// Defines the arguments accepted by this command using declarative objects.
  List<ArgumentDefinition> get argumentDefinitions;
  String get description;

  bool get hidden => false;

  String get name;
  Map<String, CliCommand> get subcommands => {};

  /// The core logic of the command. Called after successful parsing.
  FutureOr<void> execute(ArgResults argResults);

  /// Returns the usage help text for this command.
  String getUsage(String appName, List<String> commandPath) {
    final path = [appName, ...commandPath, name].join(' ');
    final buffer = StringBuffer();
    buffer.writeln(description);
    buffer.writeln('\nUsage: $path [arguments]');
    if (aliases.isNotEmpty) buffer.writeln('Aliases: ${aliases.join(', ')}');
    buffer.writeln('\nOptions:');
    buffer.writeln(argParser.usage);
    return buffer.toString();
  }

  /// Override for custom fallback behavior. Defaults to `_defaultInteractiveFallback`.
  Future<List<String>?> handleInteractiveFallback(
    ArgParserException error,
    List<String> originalArgs,
  ) async {
    return await _defaultInteractiveFallback(error, originalArgs);
  }

  /// Helper to add subcommand usage to parser help text.
  void _addSubcommandUsage(ArgParser parser) {
    if (subcommands.isNotEmpty) {
      parser.addSeparator('\nAvailable subcommands:');
      int maxLen = 0;
      subcommands.values
          .where(
            (cmd) => !cmd.hidden && cmd.name == subcommands[cmd.name]?.name,
          )
          .forEach((cmd) {
            if (cmd.name.length > maxLen) maxLen = cmd.name.length;
          });
      maxLen += 2;

      subcommands.values
          .where(
            (cmd) => !cmd.hidden && cmd.name == subcommands[cmd.name]?.name,
          ) // Unique commands
          .forEach((subCmd) {
            parser.addSeparator(
              '  ${subCmd.name.padRight(maxLen)} ${subCmd.description}',
            );
          });
    }
  }

  /// Builds the ArgParser based on `argumentDefinitions`.
  /// Override ONLY for highly custom ArgParser configuration.
  ArgParser _buildParser() {
    final parser = ArgParser(
      usageLineLength: stdout.supportsAnsiEscapes ? stdout.terminalColumns : 80,
      allowTrailingOptions: true,
    );
    parser.addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Show help for the $name command.',
    );
    for (final definition in argumentDefinitions) {
      definition.configureArgParser(parser);
    }
    _addSubcommandUsage(parser);
    return parser;
  }

  /// Default fallback logic using argument definitions and the prompter.
  Future<List<String>?> _defaultInteractiveFallback(
    ArgParserException error,
    List<String> originalArgs,
  ) async {
    stderr.writeln(
      '\nOops! Issue with arguments for "$name": ${error.message}',
    );
    stderr.writeln('Let\'s provide the details needed:');
    final newArgs = <String>[];
    try {
      for (final definition in argumentDefinitions) {
        dynamic originalValue = definition.findOriginalValue(originalArgs);
        dynamic promptedValue = await definition.promptInteractively(
          originalValue,
          prompter,
        );
        definition.addValueToArgList(newArgs, promptedValue);
      }
    } catch (e) {
      stderr.writeln('Interactive fallback failed or was cancelled: $e');
      return null; // Abort
    }
    print('\nOkay, retrying $name command with collected arguments...\n');
    return newArgs;
  }

  /// Internal method called by CliApp to handle parsing and execution flow.
  Future<void> _parseAndRun(
    List<String> args,
    String appName,
    List<String> commandPath,
  ) async {
    ArgResults results;
    try {
      results = argParser.parse(args);
      if (results.wasParsed('help')) {
        print(getUsage(appName, commandPath));
        return;
      }
    } on ArgParserException catch (e) {
      final correctedArgs = await handleInteractiveFallback(e, args);
      if (correctedArgs != null) {
        try {
          results = argParser.parse(correctedArgs);
          if (results.wasParsed('help')) {
            print(getUsage(appName, commandPath));
            return;
          }
        } on ArgParserException catch (retryError) {
          throw ArgumentParsingException(name, retryError);
        }
      } else {
        return;
      }
    }
    await execute(results); // Catch exceptions in CliApp.run
  }
}

/// A default implementation for commands that only group subcommands.
class ParentCommand extends CliCommand {
  @override
  final String name;
  @override
  final String description;
  @override
  final List<String> aliases;
  @override
  final Map<String, CliCommand> subcommands;

  ParentCommand({
    required this.name,
    required this.description,
    required InteractivePrompter prompter, // Needs prompter for base class
    this.aliases = const [],
    required List<CliCommand> commands,
  }) : subcommands = {for (var cmd in commands) cmd.name: cmd},
       super(prompter) {
    // Add aliases
    for (final cmd in commands) {
      for (final alias in cmd.aliases) {
        if (subcommands.containsKey(alias)) {
          stderr.writeln(
            'Warning: Alias "$alias" for command "${cmd.name}" conflicts with another command or alias.',
          );
        } else {
          subcommands[alias] = cmd;
        }
      }
    }
  }

  /// Parent commands have no arguments of their own.
  @override
  List<ArgumentDefinition> get argumentDefinitions => [];

  @override
  FutureOr<void> execute(ArgResults argResults) {
    stderr.writeln('Error: Command "$name" requires a subcommand.');
    stderr.writeln('Run with --help to see available subcommands.');
    exitCode = 64;
    return Future.value();
  }

  /// Fallback is not useful for parent commands.
  @override
  Future<List<String>?> handleInteractiveFallback(
    ArgParserException error,
    List<String> originalArgs,
  ) async {
    stderr.writeln('\nError parsing arguments for "$name": ${error.message}');
    stderr.writeln(
      'Parent commands require a subcommand. Use --help to see options.',
    );
    return null; // Abort
  }
}
