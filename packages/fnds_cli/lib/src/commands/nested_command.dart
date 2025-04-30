part of 'commands.dart';

/// A command that can have subcommands.
abstract class NestedCommand extends BaseCommand {
  /// Creates a new instance of [NestedCommand].
  NestedCommand() {
    // Call the public method
    addSubcommands();
  }

  /// Adds subcommands to this command.
  ///
  /// This method can be overridden by subclasses to register
  /// subcommands using [addSubcommand].
  /// It's called automatically by the constructor.
  void addSubcommands() {
    // Provide an empty default implementation.
    // Subclasses can @override this.
  }

  @override
  Future<int?> execute() async {
    // First check if we have a subcommand to run
    if (argResults!.command == null) {
      // No subcommand provided, but subcommands exist
      if (subcommands.isNotEmpty) {
        print(usage);
        return 0;
      }

      // No subcommands defined, so we're a leaf command
      // Try to use interactive fallback if needed

      // Check if interactive mode is enabled from the state manager
      final isInteractive =
          cliStateManager.getStateValueByLabel('interactive') as bool? ?? false;

      // Check if the flag was specifically set on this command
      final interactiveFlag = argResults?['interactive'] as bool? ?? false;

      if (interactiveFlag || isInteractive) {
        // The base class's run method will handle the interactive fallback
        return null;
      }
    }

    // Delegate to normal subcommand execution
    return null;
  }
}
