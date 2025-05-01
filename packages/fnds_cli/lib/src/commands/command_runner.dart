/// Command runner implementation for FNDS CLI applications.
///
/// This module extends the standard [CommandRunner] class from the args package
/// to provide enhanced functionality specific to FNDS CLI applications:
///
/// - Integrated logging with configurable log levels
/// - Built-in support for interactive fallbacks for missing arguments
/// - Global state management for CLI flags and options
/// - Standardized error handling and exit code management
///
/// The [CliCommandRunner] serves as the primary entry point for executing
/// commands within the FNDS CLI framework, providing a consistent interface
/// for handling user input, displaying help information, and running commands.
part of 'commands.dart';

/// A command runner for executing CLI commands.
///
/// This class extends [CommandRunner] to provide additional features such as
/// logging, interactive fallbacks, and global state management for CLI flags
/// and options.
class CliCommandRunner extends CommandRunner<int> {
  /// Logger instance for the command runner.
  final Logger _logger = Logger();

  /// Whether logging is enabled for this command runner.
  final bool enableLogging;

  /// Whether interactive mode is enabled by default.
  ///
  /// When enabled, missing required arguments will trigger interactive prompts.
  final bool useInteractiveFallback;

  /// The parsed command line arguments.
  ArgResults? _argResults;

  /// Creates a new [CliCommandRunner] with the given name and description.
  ///
  /// The [name] is used as the top-level command name in the help output.
  /// The [description] is displayed in the help output to provide context.
  ///
  /// The [enableLogging] parameter controls whether logging is enabled.
  /// The [logLevel] parameter sets the initial log level (defaults to [LogLevel.info]).
  /// The [useInteractiveFallback] parameter controls whether interactive mode is enabled by default.
  CliCommandRunner(
    super.name,
    super.description, {
    this.enableLogging = true,
    LogLevel logLevel = LogLevel.info,
    this.useInteractiveFallback = true,
  }) {
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

    if (enableLogging) {
      _logger.level = logLevel;
    }
  }

  /// Adds a command to the command runner.
  ///
  /// This is a convenience method for adding a [BaseCommand] to the command runner.
  /// It's equivalent to [addCommand], but with a more specific type signature.
  void addBaseCommand(BaseCommand command) {
    addCommand(command);
  }

  /// Runs the command specified by the given arguments.
  ///
  /// This method parses the arguments, handles global flags like --help and --verbose,
  /// updates the CLI state manager, and runs the appropriate command.
  ///
  /// Returns the exit code from the command, where 0 indicates success and any other
  /// value indicates an error.
  @override
  Future<int> run(Iterable<String> args) async {
    try {
      _argResults = parse(args);

      if (_argResults!['help'] == true) {
        print(usage);
        return 0;
      }

      if (_argResults!['verbose'] == true) {
        _logger.level = LogLevel.debug;
      }

      final interactiveFlag =
          _argResults!['interactive'] as bool? ?? useInteractiveFallback;
      final verboseFlag = _argResults!['verbose'] as bool? ?? false;

      cliStateManager.addMember(
        SingleCLIState<bool>('interactive', interactiveFlag),
      );
      cliStateManager.addMember(SingleCLIState<bool>('verbose', verboseFlag));

      return await runCommand(_argResults!) ?? 0;
    } on UsageException catch (e) {
      _logger.error(e.message);
      print('\nUsage: ${e.usage}');
      return 64;
    } on CommandError catch (e) {
      _logger.error(e.message);
      return e.exitCode;
    } catch (e, stackTrace) {
      _logger.error('Unexpected error: $e');
      if (_argResults != null && _argResults!['verbose'] == true) {
        _logger.debug('$stackTrace');
      }
      return 1;
    }
  }
}
