import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fnds_cli/fnds_cli.dart';
import 'package:test/test.dart';

part 'mocks/mock_io_sink.dart';
part 'mocks/mock_stdin.dart';
part 'mocks/stdout_adapter.dart';
part 'mocks/test_io_overrides.dart';
part 'utils/key_press.dart';

/// Tests for interactive input functionality
void inputTests() {
  // These tests mock stdin/stdout to simulate user interaction
  group('Input Tests', () {
    // We'll use this to capture printed output
    late StringBuffer outputBuffer;
    // We'll use this to simulate user input
    late MockStdin mockStdin;

    setUp(() {
      // Set up our output capturing buffer
      outputBuffer = StringBuffer();

      // Create a mock standard input
      mockStdin = MockStdin();

      // Redirect stdout to our buffer for testing
      IOOverrides.global = TestIOOverrides(
        mockStdout: MockIOSink(outputBuffer),
        mockStdin: mockStdin,
      );
    });

    tearDown(() {
      // Remove our IO overrides
      IOOverrides.global = null;
    });

    test('Ask function collects string input', () async {
      // Set up the mock input response
      mockStdin.simulatedInputs.add('test input');

      // Call the ask function
      String? result;
      final value = ask<String>(
        label: 'Test Label',
        question: 'Enter test input:',
        defaultValue: '',
        callback: (state) => result = state.value,
      );

      // Check that the prompt was displayed
      expect(outputBuffer.toString(), contains('Enter test input:'));
      // Check that the user input was correctly processed
      expect(value, equals('test input'));
      expect(result, equals('test input'));
    });

    test('Ask function with default value', () async {
      // User will just press Enter, accepting default
      mockStdin.simulatedInputs.add('');

      String? result;
      final value = ask<String>(
        label: 'Test Label',
        question: 'Enter input (default provided):',
        defaultValue: 'default value',
        callback: (state) => result = state.value,
      );

      expect(
        outputBuffer.toString(),
        contains('Enter input (default provided):'),
      );
      expect(value, equals('default value'));
      expect(result, equals('default value'));
    });

    test('Confirm function with Yes response', () async {
      // Simulate pressing Enter to select "Yes" (the default)
      mockStdin.simulatedInputs.add('\n');

      bool? result;
      final value = confirm(
        label: 'Confirm Test',
        question: 'Confirm? (y/n)',
        callback: (state) => result = state.value,
      );

      expect(outputBuffer.toString(), contains('Confirm?'));
      expect(value, isTrue);
      expect(result, isTrue);
    });

    test('Confirm function with No response', () async {
      // Simulate pressing down arrow and Enter to select "No"
      mockStdin.simulatedKeyPress(KeyPress.downArrow);
      mockStdin.simulatedKeyPress(KeyPress.enter);

      bool? result;
      final value = confirm(
        label: 'Confirm Test',
        question: 'Confirm? (y/n)',
        defaultValue: false, // Default to No
        callback: (state) => result = state.value,
      );

      expect(outputBuffer.toString(), contains('Confirm?'));
      expect(value, isFalse);
      expect(result, isFalse);
    });

    test('Select function picks an option', () async {
      // Simulate pressing down arrow and then Enter to select the second option
      mockStdin.simulatedKeyPress(KeyPress.downArrow);
      mockStdin.simulatedKeyPress(KeyPress.enter);

      String? result;
      final value = select<String>(
        label: 'Selection Test',
        question: 'Select an option:',
        options: ['Option 1', 'Option 2', 'Option 3'],
        callback: (state) => result = state.value,
      );

      expect(outputBuffer.toString(), contains('Select an option:'));
      expect(value, equals('Option 2'));
      expect(result, equals('Option 2'));
    });

    test('MultipleSelect function picks multiple options', () async {
      // Simulate pressing space to select first option, down arrow,
      // space to select second option, then Enter
      mockStdin.simulatedKeyPress(KeyPress.space);
      mockStdin.simulatedKeyPress(KeyPress.downArrow);
      mockStdin.simulatedKeyPress(KeyPress.space);
      mockStdin.simulatedKeyPress(KeyPress.enter);

      List<String>? result;
      final value = multipleSelect<String>(
        label: 'Multiple Selection Test',
        question: 'Select multiple options:',
        options: ['Option 1', 'Option 2', 'Option 3'],
        callback: (state) => result = state.selectedOptions,
      );

      expect(outputBuffer.toString(), contains('Select multiple options:'));
      expect(value, equals(['Option 1', 'Option 2']));
      expect(result, equals(['Option 1', 'Option 2']));
    });
  });
}
