part of 'commands.dart';

/// Utility function to check if interactive mode is enabled
///
/// This function checks both the global state and the local command arguments
/// to determine if interactive mode is enabled.
bool isInteractiveModeEnabled(ArgResults? argResults) {
  // Check global state first
  final isGloballyInteractive =
      cliStateManager.getStateValueByLabel('interactive') as bool? ?? false;

  // Then check local command arguments if that option exists
  bool isLocallyInteractive = false;
  try {
    if (argResults?.options.contains('interactive') ?? false) {
      isLocallyInteractive = argResults!['interactive'] as bool? ?? false;
    }
  } catch (_) {
    // Ignore errors if option doesn't exist
  }

  return isGloballyInteractive || isLocallyInteractive;
}
