part of 'core.dart';

/// The main orchestrator for the CLI application.
class CliApp {
  final String name;
  final String description;
  final String? version;
  final InteractivePrompter prompter;
  final Map<String, CliCommand> _commands = {};
  final ArgParser _globalParser;

  CliApp({
    required this.name,
    required this.description,
    required this.prompter,
    this.version,
    List<CliCommand> commands = const [],
  }) : _globalParser = ArgParser(
         usageLineLength:
             stdout.supportsAnsiEscapes ? stdout.terminalColumns : 80,
         allowTrailingOptions: false, // Global options should come first
       ) {
    _globalParser.addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Shows overall application help.',
    );
    if (version != null) {
      _globalParser.addFlag(
        'version',
        negatable: false,
        help: 'Shows the application version.',
      );
    }
    // Add other global options here

    for (final command in commands) {
      addCommand(command);
    }
  }

  /// Registers a top-level command.
  void addCommand(CliCommand command) {
    // Ensure command uses the same prompter instance (or handle differently if needed)
    // assert(command.prompter == this.prompter, 'Command prompter mismatch!');
    if (_commands.containsKey(command.name)) {
      throw CliException('Command "${command.name}" is already registered.');
    }
    _commands[command.name] = command;
    for (final alias in command.aliases) {
      if (_commands.containsKey(alias)) {
        stderr.writeln(
          'Warning: Alias "$alias" for command "${command.name}" conflicts with another command or alias.',
        );
      } else {
        _commands[alias] = command;
      }
    }
  }

  /// Prints the top-level application usage help.
  void printUsage() {
    print(description);
    print(
      '\nUsage: $name [global options] <command> [subcommands] [command options]',
    );
    print('\nGlobal options:');
    print(_globalParser.usage);
    print('\nAvailable commands:');
    int maxLen = 0;
    _commands.values
        .where((cmd) => !cmd.hidden && cmd.name == _commands[cmd.name]?.name)
        .forEach((cmd) {
          if (cmd.name.length > maxLen) maxLen = cmd.name.length;
        });
    maxLen += 2;
    _commands.values
        .where((cmd) => !cmd.hidden && cmd.name == _commands[cmd.name]?.name)
        .forEach(
          (cmd) => print('  ${cmd.name.padRight(maxLen)} ${cmd.description}'),
        );
    print(
      '\nRun "$name <command> --help" for more information about a command.',
    );
  }

  /// Runs the CLI application with the given arguments.
  Future<void> run(List<String> arguments) async {
    ArgResults globalResults;
    List<String> remainingArgs = List.from(arguments);

    try {
      globalResults = _globalParser.parse(remainingArgs);
      remainingArgs = globalResults.rest;
    } on ArgParserException catch (e) {
      stderr.writeln('Error parsing global options: ${e.message}\n');
      printUsage();
      exitCode = 64;
      return;
    }

    if (globalResults.wasParsed('help')) {
      printUsage();
      return;
    }
    if (version != null && globalResults.wasParsed('version')) {
      print('$name version: $version');
      return;
    }

    // --- Command Dispatch ---
    var currentCommands = _commands;
    CliCommand? targetCommand;
    final commandPath = <String>[];
    int argsConsumed = 0;

    for (int i = 0; i < remainingArgs.length; i++) {
      final potentialCommand = remainingArgs[i];
      final foundCommand = currentCommands[potentialCommand];
      if (foundCommand != null) {
        targetCommand = foundCommand;
        commandPath.add(potentialCommand);
        currentCommands = targetCommand.subcommands;
        argsConsumed++;
      } else {
        break;
      } // Not a known command/subcommand
    }
    final commandArgs = remainingArgs.sublist(argsConsumed);

    // --- Execution or Help/Error ---
    try {
      if (targetCommand == null) {
        if (remainingArgs.isNotEmpty) {
          throw CommandNotFoundException(
            commandPath.isEmpty ? remainingArgs.sublist(0, 1) : commandPath,
          );
        }
        printUsage();
        return; // No command given
      }
      // Wrap execution in try-catch to handle CommandExecutionException
      try {
        await targetCommand._parseAndRun(commandArgs, name, commandPath);
      } on CommandExecutionException catch (execErr) {
        // Re-throw specific execution errors for central handling
        rethrow;
      } catch (e, s) {
        // Catch unexpected errors during _parseAndRun or execute
        throw CommandExecutionException(targetCommand.name, e, s);
      }
    } on CliException catch (e) {
      _handleCliError(e, commandPath);
      exitCode = _getExitCodeForError(e);
    } catch (e, s) {
      // Catch unexpected errors during dispatch itself
      _handleCliError(
        CommandExecutionException(commandPath.join(' ') ?? 'Unknown', e, s),
        commandPath,
      );
      exitCode = 1; // General error
    }
  }

  /// Gets a standard exit code based on the exception type.
  int _getExitCodeForError(CliException e) {
    if (e is ArgumentParsingException || e is CommandNotFoundException) {
      return 64; // Usage error
    }
    if (e is CommandExecutionException) {
      return 70; // Internal software error
    }
    return 1; // Default general error
  }

  /// Handles known CLI exceptions and prints appropriate messages.
  void _handleCliError(CliException e, List<String> commandPath) {
    stderr.writeln('Error: ${e.message}');
    if (e is ArgumentParsingException) {
      final cmdName = e.commandName;
      final path = [
        name,
        ...commandPath.takeWhile((p) => p != cmdName),
        cmdName,
      ].join(' ');
      stderr.writeln('Run "$path --help" for usage of command "$cmdName".');
    } else if (e is CommandNotFoundException) {
      stderr.writeln('Command not found: "${e.commandPath.join(' ')}"');
      stderr.writeln('Run "$name --help" to see available commands.');
    } else if (e is CommandExecutionException) {
      // Optionally print stack trace in verbose/debug mode
      stderr.writeln(e.originalStackTrace);
    } else {
      stderr.writeln('An unexpected error occurred.');
    }
  }
}
