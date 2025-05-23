part of 'commands.dart';

/// Base class for all commands in the CLI framework.
///
/// This class provides a framework for creating commands with argument parsing,
/// logging, and support for interactive fallbacks. It is designed to be extended
/// by specific command implementations and adds additional functionality to the
/// [Command] class from the args package.
abstract class BaseCommand extends Command<int> {
  /// The logger instance for this command.
  final Logger logger = Logger();

  /// A map of argument names to their interactive fallback configurations.
  final Map<String, InteractiveFallback> _interactiveFallbacks = {};

  /// A map to store values provided through interactive fallbacks.
  final Map<String, dynamic> _interactiveValues = {};

  /// Cache of required arguments, populated during setup
  final Set<String> _requiredArguments = {};

  /// Cache for argument values to avoid multiple lookups
  final Map<String, dynamic> _argCache = {};

  /// Creates a new instance of [BaseCommand].
  BaseCommand() {
    // Add default arguments to all commands

    setupArgs(argParser);
  }

  /// Registers an argument as required and tracks it for validation
  ///
  /// Call this method when adding required arguments in setupArgs
  void addRequiredArg(String name) {
    _requiredArguments.add(name);
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
    // Check cache first to avoid repeated lookups
    if (_argCache.containsKey(name)) {
      final cachedValue = _argCache[name];
      if (cachedValue == null || cachedValue is T) {
        return cachedValue as T?;
      }
      // If type doesn't match, don't use cache and fetch fresh value
    }

    // Get the value using a single lookup in the most common case
    dynamic value;

    if (_interactiveValues.containsKey(name)) {
      // Interactive values take precedence if they exist
      value = _interactiveValues[name];
    } else {
      // Otherwise use the value from command line args
      value = argResults![name];
    }

    // Cache the value for future lookups
    _argCache[name] = value;

    // Verify type before returning
    if (value != null && value is! T) {
      throw ArgumentError(
        'Expected $T for argument "$name" but got ${value.runtimeType}',
      );
    }

    return value as T?;
  }

  @override
  FutureOr<int> run() async {
    // Reset the argument cache on each run
    _argCache.clear();

    // Handle help flag
    if (argResults!['help'] as bool) {
      print(usage);
      return 0;
    }

    try {
      // Process missing arguments once
      final usedInteractiveFallback = _handleMissingRequiredArguments();
      if (usedInteractiveFallback) {
        logger.debug('Using interactive fallback for missing arguments');
      }

      // Execute the command and return the result, defaulting to 0 if null
      return await execute() ?? 0;
    } on CommandError catch (e) {
      // Handle specific command errors with their own exit codes
      logger.error(e.message);
      return e.exitCode;
    } on ArgumentError catch (e) {
      // Convert ArgumentError to UsageError for consistent error handling
      final usageError = UsageError('Invalid argument: ${e.message}');
      logger.error(usageError.message);
      return usageError.exitCode;
    } catch (e) {
      // Generic error handling
      logger.error('Unexpected error: $e');
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
  ///   addRequiredArg('name');
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

    // If an interactive fallback is set, consider the arg required
    // This ensures better consistency for interactive args
    if (!_requiredArguments.contains(argName)) {
      _requiredArguments.add(argName);
    }
  }

  /// Sets up command-specific arguments.
  ///
  /// This method should be overridden by subclasses to add arguments
  /// specific to the command.
  void setupArgs(ArgParser argParser) {}

  /// Handles any missing required arguments using interactive fallbacks.
  ///
  /// Returns `true` if any arguments were handled interactively.
  bool _handleMissingRequiredArguments() {
    // Use the consolidated method to check interactive mode
    if (!_isInteractiveModeEnabled()) return false;

    bool handledAny = false;

    // Process missing arguments in one pass
    for (final name in _requiredArguments) {
      // Skip if already provided or no fallback available
      if (argResults!.wasParsed(name) ||
          !_interactiveFallbacks.containsKey(name)) {
        continue;
      }

      final fallback = _interactiveFallbacks[name];
      if (fallback == null) continue;

      final value = InteractiveFallbackManager.runFallback(fallback);
      _interactiveValues[name] = value;
      // Also update cache directly
      _argCache[name] = value;
      handledAny = true;
    }

    return handledAny;
  }

  /// Helper method to check if interactive mode is enabled
  ///
  /// Uses the shared utility function for consistent behavior
  bool _isInteractiveModeEnabled() {
    return isInteractiveModeEnabled(argResults);
  }
}
