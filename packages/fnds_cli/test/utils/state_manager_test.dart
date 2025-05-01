import 'dart:async';

import 'package:test/test.dart';

/// Tests for the StateManager class
void stateManagerTests() {
  group('StateManager Tests', () {
    late StateManager stateManager;

    setUp(() {
      // Initialize with an empty list of states
      stateManager = StateManager([]);
    });

    test('Initial state is empty', () {
      expect(stateManager.states, isEmpty);
      expect(stateManager.stateValues, isEmpty);
    });

    test('Adding a single state', () {
      final singleState = SingleCLIState<String>(
        label: 'username',
        value: 'testuser',
      );

      stateManager.addMember(singleState);

      expect(stateManager.states.length, equals(1));
      expect(stateManager.states[0], equals(singleState));
      expect(stateManager.stateValues.length, equals(1));
      expect(stateManager.stateValues[0], equals('testuser'));
    });

    test('Adding a group state', () {
      final groupState = GroupCLIState(
        label: 'features',
        selectedOptions: ['logging', 'auth', 'database'],
      );

      stateManager.addMember(groupState);

      expect(stateManager.states.length, equals(1));
      expect(stateManager.states[0], equals(groupState));
      expect(stateManager.stateValues.length, equals(1));
      expect(
        stateManager.stateValues[0],
        equals(['logging', 'auth', 'database']),
      );
    });

    test('Getting state value by index', () {
      stateManager.addMember(
        SingleCLIState<String>(label: 'name', value: 'John Doe'),
      );

      stateManager.addMember(SingleCLIState<int>(label: 'age', value: 30));

      expect(stateManager.getStateValueByIndex(0), equals('John Doe'));
      expect(stateManager.getStateValueByIndex(1), equals(30));
      expect(stateManager.getStateValueByIndex(2), isNull);
      expect(stateManager.getStateValueByIndex(-1), isNull);
    });

    test('Getting state value by label', () {
      stateManager.addMember(
        SingleCLIState<String>(label: 'username', value: 'johndoe'),
      );

      stateManager.addMember(SingleCLIState<bool>(label: 'admin', value: true));

      expect(stateManager.getStateValueByLabel('username'), equals('johndoe'));
      expect(stateManager.getStateValueByLabel('admin'), isTrue);
      expect(stateManager.getStateValueByLabel('nonexistent'), isNull);
    });

    test('Replacing all states', () {
      // Add some initial states
      stateManager.addMember(
        SingleCLIState<String>(label: 'initial', value: 'initial value'),
      );

      // Create new list of states
      final newStates = [
        SingleCLIState<String>(label: 'new-1', value: 'new value 1'),
        SingleCLIState<int>(label: 'new-2', value: 42),
      ];

      // Replace states
      stateManager.newList(newStates);

      expect(stateManager.states.length, equals(2));
      expect(stateManager.getStateValueByLabel('initial'), isNull);
      expect(stateManager.getStateValueByLabel('new-1'), equals('new value 1'));
      expect(stateManager.getStateValueByLabel('new-2'), equals(42));
    });

    test('Stream emits updates', () async {
      final streamEvents = <List<CLIState>>[];
      final subscription = stateManager.stream.listen(streamEvents.add);

      // Add states to trigger stream events
      stateManager.addMember(
        SingleCLIState<String>(label: 'first', value: 'first value'),
      );

      stateManager.addMember(
        SingleCLIState<String>(label: 'second', value: 'second value'),
      );

      // Wait a short time for the events to be processed
      await Future.delayed(Duration(milliseconds: 100));

      // Verify that the stream emitted the correct events
      expect(streamEvents.length, equals(2));
      expect(streamEvents[0].length, equals(1));
      expect(streamEvents[0][0].label, equals('first'));
      expect(streamEvents[1].length, equals(2));
      expect(streamEvents[1][1].label, equals('second'));

      await subscription.cancel();
    });

    test('Mixed state types', () {
      stateManager.addMember(
        SingleCLIState<String>(label: 'name', value: 'John Doe'),
      );

      stateManager.addMember(
        GroupCLIState(label: 'roles', selectedOptions: ['user', 'editor']),
      );

      stateManager.addMember(
        SingleCLIState<bool>(label: 'active', value: true),
      );

      expect(stateManager.states.length, equals(3));
      expect(stateManager.stateValues.length, equals(3));
      expect(stateManager.stateValues[0], equals('John Doe'));
      expect(stateManager.stateValues[1], equals(['user', 'editor']));
      expect(stateManager.stateValues[2], isTrue);
    });
  });
}

// Implementation of state management classes to support testing

/// Base class for CLI states
abstract class CLIState<T> {
  final String label;
  T get value;

  CLIState({required this.label});
}

/// Single value CLI state (for individual inputs)
class SingleCLIState<T> extends CLIState<T> {
  final T _value;

  @override
  T get value => _value;

  SingleCLIState({required super.label, required T value}) : _value = value;
}

/// Group CLI state (for multiple selections)
class GroupCLIState extends CLIState<List<String>> {
  final List<String> selectedOptions;

  @override
  List<String> get value => selectedOptions;

  GroupCLIState({required super.label, required this.selectedOptions});
}

/// State manager to handle collections of states
class StateManager {
  final List<CLIState> _states;
  final StreamController<List<CLIState>> _controller =
      StreamController<List<CLIState>>.broadcast();

  StateManager(List<CLIState> initialStates)
    : _states = List.from(initialStates);

  Stream<List<CLIState>> get stream => _controller.stream;

  List<CLIState> get states => List.unmodifiable(_states);

  List<dynamic> get stateValues => _states.map((state) => state.value).toList();

  void addMember(CLIState state) {
    _states.add(state);
    _controller.add(List.unmodifiable(_states));
  }

  void newList(List<CLIState> states) {
    _states.clear();
    _states.addAll(states);
    _controller.add(List.unmodifiable(_states));
  }

  dynamic getStateValueByIndex(int index) {
    if (index < 0 || index >= _states.length) {
      return null;
    }
    return _states[index].value;
  }

  dynamic getStateValueByLabel(String label) {
    final stateIndex = _states.indexWhere((state) => state.label == label);
    return getStateValueByIndex(stateIndex);
  }

  void dispose() {
    _controller.close();
  }
}
