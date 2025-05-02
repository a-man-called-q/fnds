part of '../inputs_tests.dart';

/// Represents the key press events that can be simulated in tests
enum KeyPress { upArrow, downArrow, enter, space }

/// Extension to get the byte codes for key presses
extension KeyPressCodes on KeyPress {
  int get code {
    switch (this) {
      case KeyPress.upArrow:
        return 183; // Custom code for testing up arrow
      case KeyPress.downArrow:
        return 184; // Custom code for testing down arrow
      case KeyPress.enter:
        return 10; // Line feed / Enter
      case KeyPress.space:
        return 32; // Space
    }
  }
}
