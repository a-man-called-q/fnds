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
    if (argResults!.command == null) {
      if (subcommands.isNotEmpty) {
        print(usage);
        return 0;
      }

      final isInteractive =
          cliStateManager.getStateValueByLabel('interactive') as bool? ?? false;
      final interactiveFlag = argResults?['interactive'] as bool? ?? false;

      if (interactiveFlag || isInteractive) {
        return null;
      }
    }

    return null;
  }
}
