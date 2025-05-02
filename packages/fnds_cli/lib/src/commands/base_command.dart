part of 'commands.dart';

/// Base class for defining CLI commands.
///
/// This class provides a framework for creating commands with argument parsing,
/// logging, and support for interactive fallbacks. It is designed to be extended
/// by specific command implementations.

/// Base class for all commands in the CLI framework.
///
/// This class extends the [Command] class from the args package and adds
/// additional functionality specific to the framework.
abstract class BaseCommand extends Command<int> {
  /// The logger instance for this command.
  final Logger logger = Logger();

  /// A map of argument names to their interactive fallback configurations.
  final Map<String, InteractiveFallback> _interactiveFallbacks = {};

  /// A map to store values provided through interactive fallbacks.
  final Map<String, dynamic> _interactiveValues = {};

  /// Creates a new instance of [BaseCommand].
  BaseCommand() {
    // Add default arguments to all commands
    argParser
    // Removed duplicate help flag since it's already added by the base Command class
    .addFlag(
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

  /// Gets the value of an argument, either from the command line or from an interactive fallback.
  ///
  /// This method should be used in [execute] to get argument values, as it will
  /// check both the command line arguments and any values provided through
  /// interactive fallbacks.
  T? getArg<T>(String name) {
    if (argResults!.wasParsed(name)) return argResults![name] as T?;
    if (_interactiveValues.containsKey(name)) {
      return _interactiveValues[name] as T?;
    }
    return argResults![name] as T?;
  }

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
      // Check for missing required arguments and try interactive fallback if enabled
      if (_handleMissingRequiredArguments()) {
        logger.debug('Using interactive fallback for missing arguments');
      }

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

  /// Registers an interactive fallback for a command argument.
  ///
  /// This method should be called in [setupArgs] after the argument is defined.
  /// When a required argument is missing and interactive mode is enabled,
  /// the fallback will be used to prompt the user for the value.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// void setupArgs(ArgParser argParser) {
  ///   argParser.addOption(
  ///     'name',
  ///     help: 'The name of the project',
  ///     mandatory: true,
  ///   );
  ///
  ///   setInteractiveFallback(
  ///     'name',
  ///     InteractiveFallback<String>(
  ///       inputType: InteractiveInputType.ask,
  ///       question: 'What is the name of your project?',
  ///       defaultValue: 'my-project',
  ///     ),
  ///   );
  /// }
  /// ```
  void setInteractiveFallback<T>(
    String argName,
    InteractiveFallback<T> fallback,
  ) {
    _interactiveFallbacks[argName] = fallback;
  }

  /// Sets up command-specific arguments.
  ///
  /// This method should be overridden by subclasses to add arguments
  /// specific to the command.
  void setupArgs(ArgParser argParser) {}

  /// Gets a list of required arguments that are missing from the command line.
  List<String> _getMissingRequiredArgs() {
    final missingArgs = <String>[];

    // Check if the argParser is our enhanced ArgsAdapter
    // Try to get access to the parent ArgParser that might be an ArgsAdapter
    final parser = argParser;

    // Check each name in the interactiveFallbacks map since
    // these are the arguments we want to handle interactively
    for (final name in _interactiveFallbacks.keys) {
      // Only add to missing args if:
      // 1. It exists as an option
      // 2. It wasn't provided on the command line
      // 3. And doesn't have a default value (is null)
      if (argParser.options.containsKey(name) &&
          !argResults!.wasParsed(name) &&
          argResults![name] == null) {
        missingArgs.add(name);
      }
    }

    return missingArgs;
  }

  /// Handles any missing required arguments using interactive fallbacks.
  ///
  /// Returns `true` if any arguments were handled interactively.
  bool _handleMissingRequiredArguments() {
    // Check if interactive mode is enabled from the state manager
    final isInteractive =
        cliStateManager.getStateValueByLabel('interactive') as bool? ?? false;

    // Also check if the flag was set directly on this command for backward compatibility
    // Use a try-catch to handle the case where the 'interactive' option is not defined
    bool isInteractiveLocal = false;
    try {
      if (argResults?.options.contains('interactive') ?? false) {
        isInteractiveLocal = argResults!['interactive'] as bool? ?? false;
      }
    } catch (e) {
      // Ignore the error if the 'interactive' option is not available
      // This can happen in test environments
    }

    if (!isInteractive && !isInteractiveLocal) return false;

    // Get missing required options
    final missingArgs = _getMissingRequiredArgs();
    if (missingArgs.isEmpty) return false;

    // Handle each missing argument
    for (final argName in missingArgs) {
      final fallback = _interactiveFallbacks[argName];
      if (fallback == null) continue;

      final value = InteractiveFallbackManager.runFallback(fallback);

      // We need to store the value somewhere the command can access it
      // Using a shadow private map since argResults is read-only
      _interactiveValues[argName] = value;
    }

    return missingArgs.isNotEmpty;
  }
}
