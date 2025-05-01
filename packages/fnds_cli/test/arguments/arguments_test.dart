import 'package:args/args.dart';
import 'package:test/test.dart';

/// Tests for argument parsing and handling functionality
void argumentTests() {
  group('Argument Parser Tests', () {
    late ArgumentsAdapter argumentsAdapter;

    setUp(() {
      argumentsAdapter = ArgumentsAdapter();
    });

    test('Adding flag arguments', () {
      argumentsAdapter.addFlag(
        'verbose',
        abbr: 'v',
        help: 'Enable verbose output',
        defaultsTo: false,
      );

      final result = argumentsAdapter.parse(['--verbose']);

      expect(result.hasFlag('verbose'), isTrue);
      expect(result.getFlag('verbose'), isTrue);
    });

    test('Adding option arguments', () {
      argumentsAdapter.addOption(
        'output',
        abbr: 'o',
        help: 'Output file path',
        defaultsTo: 'output.txt',
      );

      final result = argumentsAdapter.parse(['--output', 'test.txt']);

      expect(result.hasOption('output'), isTrue);
      expect(result.getOption('output'), equals('test.txt'));
    });

    test('Using default values', () {
      argumentsAdapter.addFlag('verbose', defaultsTo: false);

      argumentsAdapter.addOption('output', defaultsTo: 'default.txt');

      final result = argumentsAdapter.parse([]);

      expect(result.getFlag('verbose'), isFalse);
      expect(result.getOption('output'), equals('default.txt'));
    });

    test('Adding multi-option arguments', () {
      argumentsAdapter.addMultiOption('files', abbr: 'f', help: 'Input files');

      final result = argumentsAdapter.parse([
        '-f',
        'file1.txt',
        '-f',
        'file2.txt',
      ]);

      expect(result.hasOption('files'), isTrue);
      expect(
        result.getMultiOption('files'),
        equals(['file1.txt', 'file2.txt']),
      );
    });

    test('Using abbreviated argument names', () {
      argumentsAdapter.addFlag('verbose', abbr: 'v');

      argumentsAdapter.addOption('output', abbr: 'o');

      final result = argumentsAdapter.parse(['-v', '-o', 'test.txt']);

      expect(result.getFlag('verbose'), isTrue);
      expect(result.getOption('output'), equals('test.txt'));
    });

    test('Parsing flags with negation', () {
      argumentsAdapter.addFlag('verbose', negatable: true, defaultsTo: true);

      final result = argumentsAdapter.parse(['--no-verbose']);

      expect(result.getFlag('verbose'), isFalse);
    });

    test('Multiple argument types together', () {
      argumentsAdapter.addFlag('verbose', abbr: 'v');
      argumentsAdapter.addOption('output', abbr: 'o');
      argumentsAdapter.addMultiOption('files', abbr: 'f');

      final result = argumentsAdapter.parse([
        '-v',
        '-o',
        'result.txt',
        '-f',
        'input1.txt',
        '-f',
        'input2.txt',
      ]);

      expect(result.getFlag('verbose'), isTrue);
      expect(result.getOption('output'), equals('result.txt'));
      expect(
        result.getMultiOption('files'),
        equals(['input1.txt', 'input2.txt']),
      );
    });

    test('Handling unknown arguments', () {
      argumentsAdapter.addFlag('verbose');

      expect(
        () => argumentsAdapter.parse(['--unknown']),
        throwsA(isA<Exception>()),
      );
    });

    test('Allowed values validation', () {
      argumentsAdapter.addOption(
        'mode',
        allowed: ['debug', 'release', 'profile'],
        defaultsTo: 'debug',
      );

      final validResult = argumentsAdapter.parse(['--mode', 'release']);
      expect(validResult.getOption('mode'), equals('release'));

      expect(
        () => argumentsAdapter.parse(['--mode', 'invalid']),
        throwsA(isA<Exception>()),
      );
    });
  });
}

/// Adapter class to wrap ArgParser functionality for testing
class ArgumentsAdapter {
  final ArgParser _parser = ArgParser();

  void addFlag(
    String name, {
    String? abbr,
    String? help,
    bool? defaultsTo,
    bool negatable = true,
  }) {
    _parser.addFlag(
      name,
      abbr: abbr,
      help: help,
      defaultsTo: defaultsTo,
      negatable: negatable,
    );
  }

  void addMultiOption(
    String name, {
    String? abbr,
    String? help,
    List<String>? defaultsTo,
    List<String>? allowed,
  }) {
    _parser.addMultiOption(
      name,
      abbr: abbr,
      help: help,
      defaultsTo: defaultsTo,
      allowed: allowed,
    );
  }

  void addOption(
    String name, {
    String? abbr,
    String? help,
    String? defaultsTo,
    List<String>? allowed,
  }) {
    _parser.addOption(
      name,
      abbr: abbr,
      help: help,
      defaultsTo: defaultsTo,
      allowed: allowed,
    );
  }

  ArgumentsResult parse(List<String> args) {
    final results = _parser.parse(args);
    return ArgumentsResult(results);
  }
}

/// Wrapper for ArgResults to provide type-safe accessors
class ArgumentsResult {
  final ArgResults _results;

  ArgumentsResult(this._results);

  bool getFlag(String name) => _results[name] as bool;

  List<String> getMultiOption(String name) => _results[name] as List<String>;

  String getOption(String name) => _results[name] as String;

  bool hasFlag(String name) => _results.options.contains(name);

  bool hasOption(String name) => _results.options.contains(name);
}
