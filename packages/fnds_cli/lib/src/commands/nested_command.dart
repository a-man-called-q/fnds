part of 'commands.dart';

/// A command that can have subcommands.
abstract class NestedCommand extends BaseCommand {
  /// Creates a new instance of [NestedCommand].
  NestedCommand() {
    addSubcommands();
  }

  /// Adds subcommands to this command.
  ///
  /// This method can be overridden by subclasses to register
  /// subcommands using [addSubcommand].
  /// It's called automatically by the constructor.
  void addSubcommands() {}

  @override
  Future<int?> execute() async {
    // If no subcommand was specified but we have subcommands available,
    // show usage information
    if (argResults!.command == null && subcommands.isNotEmpty) {
      print(usage);
      return 0;
    }

    // At this point, either:
    // 1. A subcommand was specified (handled by CommandRunner)
    // 2. No subcommand was specified and we don't have subcommands
    // 3. No subcommand was specified but we're in interactive mode

    // Check if we're in interactive mode for handling case 2
    if (isInteractiveModeEnabled(argResults)) {
      // Custom handling for interactive mode can go here
      return null;
    }

    // Default implementation returns null to allow subclasses to handle
    // execution if they override this method
    return null;
  }
}
