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
  List<CLIState> _states;
  final StreamController<List<CLIState>> _controller =
      StreamController<List<CLIState>>.broadcast();

  /// Creates a StateManager with an initial list of states.
  ///
  /// The provided list becomes the initial state collection.
  StateManager(this._states);

  /// Returns an unmodifiable view of all managed states.
  List<CLIState> get states => List.unmodifiable(_states);

  /// Returns a list of all state values, extracting the appropriate values
  /// based on the type of state (SingleCLIState or GroupCLIState).
  List<dynamic> get stateValues =>
      _states
          .map((state) {
            if (state is GroupCLIState) {
              return state.selectedOptions;
            } else if (state is SingleCLIState) {
              return state.value;
            }
            return null;
          })
          .where((value) => value != null)
          .toList();

  /// A broadcast stream of state changes that can be subscribed to.
  Stream<List<CLIState>> get stream => _controller.stream;

  /// Adds a new state to the collection and broadcasts the update.
  ///
  /// Parameters:
  /// - [newState]: The CLIState to add to the collection
  void addMember(CLIState newState) {
    _states.add(newState);
    _controller.add(List.unmodifiable(_states));
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
    if (_states[index] is GroupCLIState) {
      return (_states[index] as GroupCLIState).selectedOptions;
    } else if (_states[index] is SingleCLIState) {
      return (_states[index] as SingleCLIState).value;
    }
    return null;
  }

  /// Retrieves a state value by its label.
  ///
  /// Returns null if no state with the specified label is found.
  ///
  /// Parameters:
  /// - [label]: The label of the state to retrieve
  ///
  /// Returns the value of the state with the specified label.
  dynamic getStateValueByLabel(String label) {
    for (final state in _states) {
      if (state.label != null && state.label == label) {
        if (state is GroupCLIState) {
          return state.selectedOptions;
        } else if (state is SingleCLIState) {
          return state.value;
        }
      }
    }
    return null;
  }

  /// Replaces the entire state collection with a new list and broadcasts the update.
  ///
  /// Parameters:
  /// - [newState]: The new list of states to use
  void newList(List<CLIState> newState) {
    _states = List.from(newState);
    _controller.add(List.unmodifiable(_states));
  }
}
