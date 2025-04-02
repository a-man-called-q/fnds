part of 'utils.dart';

class StateManager {
  List<CLIState> _states;
  final StreamController<List<CLIState>> _controller =
      StreamController<List<CLIState>>.broadcast();

  StateManager(this._states);

  List<CLIState> get states => List.unmodifiable(_states);

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

  Stream<List<CLIState>> get stream => _controller.stream;

  void addMember(CLIState newState) {
    _states.add(newState);
    _controller.add(List.unmodifiable(_states));
  }

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

  void newList(List<CLIState> newState) {
    _states = List.from(newState);
    _controller.add(List.unmodifiable(_states));
  }
}
