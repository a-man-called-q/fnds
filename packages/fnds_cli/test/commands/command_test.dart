import 'package:fnds_cli/fnds_cli.dart';
import 'package:test/test.dart';

// Add main function for standalone execution
void main() {
  commandTests();
}

/// Tests for command hierarchy and command runner functionality
void commandTests() {
  group('Command Runner Tests', () {
    late CliCommandRunner runner;

    setUp(() {
      runner = createTestRunner('test-cli', 'CLI for testing purposes');
    });

    test('Command runner initialization', () {
      expect(runner, isNotNull);
      expect(runner.executableName, equals('test-cli'));
      expect(runner.description, equals('CLI for testing purposes'));
    });

    test('Adding base commands', () {
      final createCommand = TestCreateCommand();
      runner.addBaseCommand(createCommand);

      expect(runner.commands.containsKey('create'), isTrue);
      expect(runner.commands['create'], equals(createCommand));
    });

    test('Command execution with arguments', () async {
      final createCommand = TestCreateCommand();
      runner.addBaseCommand(createCommand);

      // Use a custom flag instead of verbose since verbose is no longer a default flag
      final exitCode = await runner.run(['create', '--custom-flag']);

      verifyCommandExecution(
        exitCode: exitCode,
        command: createCommand,
        expectedValues: {'customFlag': true},
      );
    });

    test('Nested command execution', () async {
      final parentCommand = TestCreateCommand();
      final nestedCommand = TestNestedCommand();
      parentCommand.addSubcommand(nestedCommand);
      runner.addBaseCommand(parentCommand);

      final exitCode = await runner.run([
        'create',
        'nested',
        '--option',
        'test-value',
      ]);

      verifyCommandExecution(
        exitCode: exitCode,
        command: nestedCommand,
        expectedValues: {'optionValue': 'test-value'},
      );
    });

    test('Command with unknown arguments throws exception', () async {
      final createCommand = TestCreateCommand();
      runner.addBaseCommand(createCommand);

      // Instead of expecting an exception, check that it returns a non-zero exit code
      final exitCode = await runner.run(['create', '--unknown-arg']);
      expect(exitCode, equals(64)); // 64 is the exit code for usage errors
    });

    test('Unknown command throws exception', () async {
      // Instead of expecting an exception, check that it returns a non-zero exit code
      final exitCode = await runner.run(['unknown-command']);
      expect(exitCode, equals(64)); // 64 is the exit code for usage errors
    });
  });

  group('BaseCommand Tests', () {
    late CliCommandRunner runner;
    late TestBaseCommand command;

    setUp(() {
      runner = createTestRunner('test-cli', 'Base Test Runner');
      command = TestBaseCommand();
      runner.addBaseCommand(command);
    });

    test('BaseCommand initialization', () {
      expect(command.name, equals('test'));
      expect(command.description, equals('Test command'));
    });

    test('BaseCommand argument setup', () {
      // Removed check for verbose flag since it's no longer a default argument
      expect(command.argParser.options.containsKey('output'), isTrue);
    });

    test('BaseCommand execution', () async {
      final exitCode = await runner.run(['test', '--output', 'test.txt']);

      verifyCommandExecution(
        exitCode: exitCode,
        command: command,
        expectedValues: {'outputPath': 'test.txt'},
      );
    });
  });

  group('NestedCommand Tests', () {
    late CliCommandRunner runner;
    late TestNestedParent parentCommand;
    late TestNestedChild childCommand;

    setUp(() {
      runner = createTestRunner('test-cli', 'Nested Test Runner');
      runner.argParser.addOption('parent-option', help: 'Global parent option');

      parentCommand = TestNestedParent();
      childCommand = TestNestedChild();
      parentCommand.addSubcommand(childCommand);
      runner.addBaseCommand(parentCommand);
    });

    test('NestedCommand adds subcommands', () {
      expect(parentCommand.subcommands.containsKey('child'), isTrue);
      expect(parentCommand.subcommands['child'], equals(childCommand));
      expect(childCommand.parent, equals(parentCommand));
    });

    test('NestedCommand argument passing', () async {
      final exitCode = await runner.run([
        '--parent-option',
        'parent-value',
        'parent',
        'child',
        '--child-option',
        'child-value',
      ]);

      verifyCommandExecution(
        exitCode: exitCode,
        command: childCommand,
        expectedValues: {
          'parentOption': 'parent-value',
          'childOption': 'child-value',
        },
      );
    });
  });
}

/// Creates a standardized test command runner
CliCommandRunner createTestRunner(String name, String description) {
  return CliCommandRunner(name, description, enableLogging: false);
}

/// Verifies command execution results
void verifyCommandExecution({
  required int exitCode,
  required dynamic command,
  Map<String, dynamic> expectedValues = const {},
}) {
  expect(exitCode, equals(0));
  expect(command.executed, isTrue);

  for (final entry in expectedValues.entries) {
    expect(command.getPropertyValue(entry.key), equals(entry.value));
  }
}

class TestBaseCommand extends TestCommandBase {
  String outputPath = '';

  @override
  String get description => 'Test command';

  @override
  String get name => 'test';

  // Add direct property access method
  dynamic getPropertyValue(String propertyName) {
    if (propertyName == 'outputPath') {
      return outputPath;
    }
    throw ArgumentError('Unknown property: $propertyName');
  }

  @override
  Future<int> processArguments() async {
    if (argResults != null && argResults!.wasParsed('output')) {
      outputPath = argResults!['output'] as String;
    }
    return 0;
  }

  @override
  void setupArgs(argParser) {
    super.setupArgs(argParser);
    // Add option for testing
    argParser.addOption('output', abbr: 'o', defaultsTo: 'output.txt');
  }
}

/// Base class for test commands to reduce duplicate code
abstract class TestCommandBase extends BaseCommand {
  bool executed = false;

  @override
  Future<int> execute() async {
    executed = true;
    return processArguments();
  }

  /// Process command-specific arguments
  Future<int> processArguments();
}

class TestCreateCommand extends NestedCommand {
  bool executed = false;
  bool customFlag = false;

  @override
  String get description => 'Test create command';

  @override
  String get name => 'create';

  @override
  Future<int> execute() async {
    executed = true;
    customFlag = argResults!['custom-flag'] as bool;
    return 0;
  }

  // Add direct property access method
  dynamic getPropertyValue(String propertyName) {
    if (propertyName == 'customFlag') {
      return customFlag;
    }
    throw ArgumentError('Unknown property: $propertyName');
  }

  @override
  void setupArgs(argParser) {
    super.setupArgs(argParser);
    argParser.addFlag('custom-flag', help: 'Custom flag for testing');
  }
}

class TestNestedChild extends BaseCommand {
  bool executed = false;
  String parentOption = '';
  String childOption = '';

  @override
  String get description => 'Test child command';

  @override
  String get name => 'child';

  @override
  Future<int> execute() async {
    executed = true;
    parentOption = globalResults!['parent-option'] as String;
    childOption = argResults!['child-option'] as String;
    return 0;
  }

  // Add direct property access method
  dynamic getPropertyValue(String propertyName) {
    if (propertyName == 'parentOption') {
      return parentOption;
    }
    if (propertyName == 'childOption') {
      return childOption;
    }
    throw ArgumentError('Unknown property: $propertyName');
  }

  @override
  void setupArgs(argParser) {
    super.setupArgs(argParser);
    argParser.addOption('child-option', help: 'Child option');
  }
}

class TestNestedCommand extends BaseCommand {
  bool executed = false;
  String optionValue = '';

  @override
  String get description => 'Test nested command';

  @override
  String get name => 'nested';

  @override
  Future<int> execute() async {
    executed = true;
    optionValue = argResults!['option'] as String;
    return 0;
  }

  // Add direct property access method
  dynamic getPropertyValue(String propertyName) {
    if (propertyName == 'optionValue') {
      return optionValue;
    }
    throw ArgumentError('Unknown property: $propertyName');
  }

  @override
  void setupArgs(argParser) {
    super.setupArgs(argParser);
    argParser.addOption('option', help: 'Test option');
  }
}

class TestNestedParent extends NestedCommand {
  @override
  String get description => 'Test parent command';

  @override
  String get name => 'parent';

  @override
  Future<int> execute() async {
    print('TestNestedParent executed');
    return 0;
  }

  // Add direct property access method
  dynamic getPropertyValue(String propertyName) {
    throw ArgumentError('Unknown property: $propertyName');
  }
}

/// Extension to get property values by name for verification
extension PropertyAccess on dynamic {
  dynamic getPropertyValue(String propertyName) {
    // Handle specific property access directly based on runtime type
    switch (propertyName) {
      case 'customFlag':
        if (this is TestCreateCommand) {
          return (this as TestCreateCommand).customFlag;
        }
        break;
      case 'outputPath':
        if (this is TestBaseCommand) {
          return (this as TestBaseCommand).outputPath;
        }
        break;
      case 'optionValue':
        if (this is TestNestedCommand) {
          return (this as TestNestedCommand).optionValue;
        }
        break;
      case 'parentOption':
        if (this is TestNestedChild) {
          return (this as TestNestedChild).parentOption;
        }
        break;
      case 'childOption':
        if (this is TestNestedChild) {
          return (this as TestNestedChild).childOption;
        }
        break;
    }
    throw ArgumentError('Unknown property: $propertyName on $runtimeType');
  }
}
