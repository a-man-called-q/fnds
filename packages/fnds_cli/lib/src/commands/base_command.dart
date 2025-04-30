part of 'commands.dart';

/// Base class for all commands in the CLI framework.
///
/// This class extends the [Command] class from the args package and adds
/// additional functionality specific to the framework.
abstract class BaseCommand extends Command<int> {
  /// The logger instance for this command.
  final Logger logger = Logger();

  /// Creates a new instance of [BaseCommand].
  BaseCommand() {
    // Add default arguments to all commands
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
      );

    setupArgs(argParser);
  }

  /// Executes the command logic.
  ///
  /// This method should be implemented by all subclasses to provide
  /// the actual command functionality. It can return an exit code,
  /// where 0 means success and anything else indicates an error.
  FutureOr<int?> execute();

  @override
  FutureOr<int> run() async {
    // Handle help flag
    if (argResults!['help'] as bool) {
      print(usage);
      return 0;
    }

    // Setup verbose logging if requested
    if (argResults!['verbose'] as bool) {
      logger.level = LogLevel.debug;
    }

    try {
      return await execute() ?? 0;
    } on CommandError catch (e) {
      logger.error(e.message);
      return e.exitCode;
    } catch (e, stackTrace) {
      logger.error('Unexpected error: $e');
      if (argResults!['verbose'] as bool) {
        logger.debug('$stackTrace');
      }
      return 1;
    }
  }

  /// Sets up command-specific arguments.
  ///
  /// This method should be overridden by subclasses to add arguments
  /// specific to the command.
  void setupArgs(ArgParser argParser) {}
}
