import 'package:test/test.dart';

import 'arguments/arguments_test.dart';
import 'commands/command_test.dart';
import 'inputs/inputs_tests.dart';
import 'utils/state_manager_test.dart';

void main() {
  group('FNDS CLI Package Tests', () {
    // Run command tests
    commandTests();

    // Run argument tests
    argumentTests();

    // Run input tests
    inputTests();

    // Run state manager tests
    stateManagerTests();
  });
}
