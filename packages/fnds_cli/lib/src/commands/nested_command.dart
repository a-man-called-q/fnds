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

  // addSubcommand remains public as it was already

  @override
  Future<int?> execute() async {
    // ... (rest of the execute method is fine) ...
    if (argResults!.command == null && subcommands.isNotEmpty) {
      print(usage);
      return 0;
    }
    return null;
  }
}
