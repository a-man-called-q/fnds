part of 'utils.dart';

/// Manages state for CLI interactions and provides access to stored values.
///
/// The [StateManager] class maintains a collection of [CLIState] objects and provides
/// methods for adding, retrieving, and manipulating states. It also includes a stream
/// for reactive updates when states change.
///
/// This class is essential for:
/// - Storing user inputs from various CLI prompts
/// - Retrieving values by index or label
/// - Subscribing to state changes through the stream API
class StateManager {
  // Use a Map for label-based lookups which are much more efficient than list iteration
  final Map<String?, CLIState> _statesByLabel = {};
  final List<CLIState> _states = [];
  final StreamController<List<CLIState>> _controller =
      StreamController<List<CLIState>>.broadcast();

  /// Creates a StateManager with an initial list of states.
  ///
  /// The provided list becomes the initial state collection.
  StateManager(List<CLIState> initialStates) {
    // Initialize both data structures efficiently
    if (initialStates.isNotEmpty) {
      _states.addAll(initialStates);

      // Pre-populate the lookup map
      for (final state in initialStates) {
        if (state.label != null) {
          _statesByLabel[state.label] = state;
        }
      }

      // Notify listeners of initial state
      _controller.add(List.unmodifiable(_states));
    }
  }

  /// Returns an unmodifiable view of all managed states.
  List<CLIState> get states => List.unmodifiable(_states);

  /// Returns a list of all state values, extracting the appropriate values
  /// based on the type of state.
  List<dynamic> get stateValues {
    // Pre-allocate with exact capacity for better performance
    final result = List<dynamic>.filled(_states.length, null, growable: true);

    for (int i = 0; i < _states.length; i++) {
      final state = _states[i];
      if (state is GroupCLIState) {
        result[i] = state.selectedOptions;
      } else if (state is SingleCLIState) {
        result[i] = state.value;
      }
    }

    return result.where((value) => value != null).toList();
  }

  /// A broadcast stream of state changes that can be subscribed to.
  Stream<List<CLIState>> get stream => _controller.stream;

  /// Adds a new state to the collection and broadcasts the update.
  ///
  /// Parameters:
  /// - [newState]: The CLIState to add to the collection
  void addMember(CLIState newState) {
    _states.add(newState);

    // Update the lookup map if the state has a label
    if (newState.label != null) {
      _statesByLabel[newState.label] = newState;
    }

    _controller.add(List.unmodifiable(_states));
  }

  /// Dispose resources when no longer needed
  void dispose() {
    _controller.close();
  }

  /// Retrieves a state value by its index in the collection.
  ///
  /// Returns null if the index is out of bounds.
  ///
  /// Parameters:
  /// - [index]: The zero-based index of the state to retrieve
  ///
  /// Returns the value of the state at the specified index.
  dynamic getStateValueByIndex(int index) {
    if (index < 0 || index >= _states.length) {
      return null;
    }

    final state = _states[index];
    return _extractValue(state);
  }

  /// Retrieves a state value by its label.
  ///
  /// Returns null if no state with the specified label is found.
  ///
  /// Parameters:
  /// - [label]: The label of the state to retrieve
  ///
  /// Returns the value of the state with the specified label.
  dynamic getStateValueByLabel(String? label) {
    // Direct map lookup instead of list iteration
    final state = _statesByLabel[label];
    return state != null ? _extractValue(state) : null;
  }

  /// Replaces the entire state collection with a new list and broadcasts the update.
  ///
  /// Parameters:
  /// - [newStates]: The new list of states to use
  void newList(List<CLIState> newStates) {
    _states.clear();
    _statesByLabel.clear();

    _states.addAll(newStates);

    // Update the lookup map
    for (final state in newStates) {
      if (state.label != null) {
        _statesByLabel[state.label] = state;
      }
    }

    _controller.add(List.unmodifiable(_states));
  }

  /// Helper method to extract value from a state based on its type
  dynamic _extractValue(CLIState state) {
    if (state is GroupCLIState) {
      return state.selectedOptions;
    } else if (state is SingleCLIState) {
      return state.value;
    }
    return null;
  }
}
