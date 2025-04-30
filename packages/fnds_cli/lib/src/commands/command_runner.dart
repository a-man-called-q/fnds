part of 'commands.dart';

/// A command runner for CLI applications.
///
/// This class extends the [CommandRunner] from args package and adds
/// additional functionality specific to the framework, such as consistent
/// error handling and logging.
class CliCommandRunner extends CommandRunner<int> {
  /// The logger instance for this command runner.
  final Logger _logger = Logger();

  /// Whether to enable logging.
  final bool enableLogging;

  /// Whether to enable interactive fallback for commands by default.
  final bool useInteractiveFallback;

  /// Store the parsed results to access in catch blocks
  ArgResults? _argResults;

  /// Creates a new instance of [CliCommandRunner].
  ///
  /// The [name] is the name of the executable, and [description] is a
  /// description of what the executable does.
  CliCommandRunner(
    super.name,
    super.description, {
    this.enableLogging = true,
    LogLevel logLevel = LogLevel.info,
    this.useInteractiveFallback = true,
  }) {
    // Add global options
    argParser
      ..addFlag(
        'help',
        abbr: 'h',
        help: 'Print this usage information.',
        negatable: false,
      )
      ..addFlag(
        'verbose',
        abbr: 'v',
        help: 'Show verbose output.',
        negatable: false,
      )
      ..addFlag(
        'interactive',
        help: 'Enable interactive mode for handling missing arguments.',
        defaultsTo: useInteractiveFallback,
      );

    // Initialize logger
    if (enableLogging) {
      _logger.level = logLevel;
    }
  }

  /// Adds a root-level command to the command runner.
  void addBaseCommand(BaseCommand command) {
    addCommand(command);
  }

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      // Parse arguments
      _argResults = parse(args);

      // Handle top-level help flag
      if (_argResults!['help'] == true) {
        print(usage);
        return 0;
      }

      // Set verbose logging if requested
      if (_argResults!['verbose'] == true) {
        _logger.level = LogLevel.debug;
      }

      // Store global flags in the state manager
      final interactiveFlag =
          _argResults!['interactive'] as bool? ?? useInteractiveFallback;
      final verboseFlag = _argResults!['verbose'] as bool? ?? false;

      // Add global flags to state manager
      cliStateManager.addMember(
        SingleCLIState<bool>('interactive', interactiveFlag),
      );
      cliStateManager.addMember(SingleCLIState<bool>('verbose', verboseFlag));

      // Run the command
      return await runCommand(_argResults!) ?? 0;
    } on UsageException catch (e) {
      // Handle command usage errors
      _logger.error(e.message);
      print('');
      print('Usage: ${e.usage}');
      return 64; // EX_USAGE in BSD
    } on CommandError catch (e) {
      // Handle command execution errors
      _logger.error(e.message);
      return e.exitCode;
    } catch (e, stackTrace) {
      // Handle unexpected errors
      _logger.error('Unexpected error: $e');

      // Print stack trace in verbose mode
      if (_argResults != null && _argResults!['verbose'] == true) {
        _logger.debug('$stackTrace');
      }

      return 1;
    }
  }
}
